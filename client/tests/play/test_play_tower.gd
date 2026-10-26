extends UnitTestCase
## The tower of one run (`design.md` `### tower` and `### score`): the slide, the perfect drop, the trims on both
## sides, the miss, the wait between blocks, the regrow of a perfect streak, the streak bonus limit and the speed.

## Game ms the slide helper steps at most before it gives up.
const _MAX_SLIDE_MS: int = 20000


func before_each() -> void:
	super()
	assert_true(LogCore.init(), "LogCore.init")
	assert_true(EventCore.init(), "EventCore.init")
	assert_true(TimeCore.init(), "TimeCore.init")
	assert_true(LocalDataCore.init(), "LocalDataCore.init")
	assert_true(LocalDataCore.load_device_file(), "LocalDataCore.load_device_file")
	assert_true(ResourceCore.init(), "ResourceCore.init")
	assert_true(DataCore.init(), "DataCore.init")
	assert_true(await DataCore.load(null), "DataCore.load")
	assert_gt(GameSetting.block_width(), GameSetting.perfect_tolerance(), "the game data is loaded")


func after_each() -> void:
	super()
	BootstrapCoreDev.shutdown()


## Advances the tower 1 game ms at a time until the sliding block's offset is within `margin` of `target`.
func _slide_to(tower: PlayTower, target: int, margin: int = 0) -> bool:
	for i: int in _MAX_SLIDE_MS:
		if tower.phase == PlayTower.Phase.SLIDING and absi(tower.offset() - target) <= margin:
			return true
		tower.advance(1)
	return false


## Waits out the delay after a drop so the next block slides.
func _wait_next(tower: PlayTower) -> void:
	tower.advance(GameSetting.next_block_delay())


func _perfect(tower: PlayTower) -> PlayTower.Drop:
	assert_true(_slide_to(tower, 0, GameSetting.perfect_tolerance()), "the block lines up with the top block")
	var drop: PlayTower.Drop = tower.drop()
	_wait_next(tower)
	return drop


func test_a_new_tower_has_the_base_slab_and_a_block_sliding_from_the_left() -> void:
	var tower: PlayTower = PlayTower.new()
	var width: int = GameSetting.block_width()
	assert_eq(tower.blocks(), 0)
	assert_eq(tower.top_width(), width)
	assert_eq(tower.top_left(), -UtilCore.floor_div(width, 2))
	assert_eq(tower.phase, PlayTower.Phase.SLIDING)
	assert_eq(tower.moving_width, width)
	assert_eq(tower.offset(), -GameSetting.slide_half_range())
	assert_eq(tower.speed(), GameSetting.slide_speed())


func test_the_block_slides_at_the_speed_and_turns_at_the_far_end() -> void:
	var tower: PlayTower = PlayTower.new()
	var half: int = GameSetting.slide_half_range()
	var speed: int = GameSetting.slide_speed()
	tower.advance(1000)
	assert_eq(tower.offset(), -half + speed)
	var turn_ms: int = UtilCore.floor_div(2 * half * PlayConstants.MS_PER_SECOND, speed)
	assert_eq(tower.offset_at(turn_ms + 1000), half - (UtilCore.floor_div(speed * (turn_ms + 1000), PlayConstants.MS_PER_SECOND) - 2 * half))


func test_a_perfect_drop_keeps_the_width_and_scores_the_streak_bonus() -> void:
	var tower: PlayTower = PlayTower.new()
	assert_true(_slide_to(tower, GameSetting.perfect_tolerance()))
	assert_eq(tower.drop(), PlayTower.Drop.PERFECT)
	assert_eq(tower.blocks(), 1)
	assert_eq(tower.top_width(), GameSetting.block_width())
	assert_eq(tower.top_left(), -UtilCore.floor_div(GameSetting.block_width(), 2))
	assert_eq(tower.score, 2)
	assert_eq(tower.streak, 1)
	assert_eq(tower.perfects, 1)
	assert_eq(tower.cut_width, 0)


func test_a_drop_past_the_top_block_cuts_the_right_overhang() -> void:
	var tower: PlayTower = PlayTower.new()
	var gap: int = GameSetting.perfect_tolerance() + 40
	var base_left: int = tower.top_left()
	var width: int = tower.top_width()
	assert_true(_slide_to(tower, gap))
	assert_eq(tower.drop(), PlayTower.Drop.TRIM)
	assert_eq(tower.top_width(), width - gap)
	assert_eq(tower.top_left(), base_left + gap)
	assert_eq(tower.cut_left, base_left + width)
	assert_eq(tower.cut_width, gap)
	assert_eq(tower.score, 1)
	assert_eq(tower.streak, 0)


func test_a_drop_before_the_top_block_cuts_the_left_overhang() -> void:
	var tower: PlayTower = PlayTower.new()
	var gap: int = GameSetting.perfect_tolerance() + 60
	var base_left: int = tower.top_left()
	var width: int = tower.top_width()
	assert_true(_slide_to(tower, -gap))
	assert_eq(tower.drop(), PlayTower.Drop.TRIM)
	assert_eq(tower.top_width(), width - gap)
	assert_eq(tower.top_left(), base_left)
	assert_eq(tower.cut_left, base_left - gap)
	assert_eq(tower.cut_width, gap)


func test_a_block_that_misses_the_tower_ends_the_run() -> void:
	var tower: PlayTower = PlayTower.new()
	assert_eq(tower.drop(), PlayTower.Drop.MISS)
	assert_eq(tower.phase, PlayTower.Phase.FALLEN)
	assert_eq(tower.blocks(), 0)
	assert_eq(tower.score, 0)
	tower.advance(1000)
	assert_eq(tower.drop(), PlayTower.Drop.NONE)


func test_the_next_block_comes_from_the_right_after_the_wait() -> void:
	var tower: PlayTower = PlayTower.new()
	assert_true(_slide_to(tower, 0))
	tower.drop()
	assert_eq(tower.phase, PlayTower.Phase.WAITING)
	assert_eq(tower.drop(), PlayTower.Drop.NONE)
	tower.advance(GameSetting.next_block_delay() - 1)
	assert_eq(tower.phase, PlayTower.Phase.WAITING)
	tower.advance(1)
	assert_eq(tower.phase, PlayTower.Phase.SLIDING)
	assert_eq(tower.moving_dir, -1)
	assert_eq(tower.offset(), GameSetting.slide_half_range())
	assert_eq(tower.speed(), GameSetting.slide_speed() + GameSetting.slide_speed_step())


func test_a_perfect_streak_grows_the_block_back_up_to_the_start_width() -> void:
	var tower: PlayTower = PlayTower.new()
	var gap: int = GameSetting.perfect_tolerance() + GameSetting.regrow_amount() + 10
	assert_true(_slide_to(tower, gap))
	tower.drop()
	_wait_next(tower)
	var narrow: int = tower.top_width()
	for i: int in GameSetting.regrow_streak() - 1:
		assert_eq(_perfect(tower), PlayTower.Drop.PERFECT)
		assert_eq(tower.top_width(), narrow, "no growth before the streak reaches the regrow count")
	assert_eq(_perfect(tower), PlayTower.Drop.PERFECT)
	var grown: int = mini(narrow + GameSetting.regrow_amount(), GameSetting.block_width())
	assert_eq(tower.top_width(), grown)
	assert_gt(tower.grew, 0)
	for i: int in 3:
		_perfect(tower)
	assert_eq(tower.top_width(), GameSetting.block_width(), "the width stops at the start width")


func test_the_streak_bonus_stops_at_its_limit_and_a_trim_resets_the_streak() -> void:
	var tower: PlayTower = PlayTower.new()
	var bonus_max: int = GameSetting.perfect_bonus_max()
	var expected: int = 0
	for i: int in bonus_max + 2:
		assert_eq(_perfect(tower), PlayTower.Drop.PERFECT)
		expected += 1 + mini(i + 1, bonus_max)
	assert_eq(tower.score, expected)
	assert_eq(tower.best_streak, bonus_max + 2)
	assert_true(_slide_to(tower, GameSetting.perfect_tolerance() + 20, 1))
	assert_eq(tower.drop(), PlayTower.Drop.TRIM)
	assert_eq(tower.streak, 0)
	assert_eq(tower.best_streak, bonus_max + 2)


func test_the_speed_grows_per_block_up_to_its_limit() -> void:
	var tower: PlayTower = PlayTower.new()
	var limit: int = GameSetting.slide_speed_max()
	var blocks_to_limit: int = UtilCore.floor_div(limit - GameSetting.slide_speed() + GameSetting.slide_speed_step() - 1,
		GameSetting.slide_speed_step())
	for i: int in blocks_to_limit + 2:
		_perfect(tower)
	assert_eq(tower.speed(), limit)


func test_two_towers_with_the_same_inputs_end_the_same() -> void:
	var a: PlayTower = PlayTower.new()
	var b: PlayTower = PlayTower.new()
	for tower: PlayTower in [a, b]:
		for ms: int in PackedInt32Array([915, 700, 1300, 400]):
			tower.advance(ms)
			tower.drop()
			_wait_next(tower)
	assert_eq(a.score, b.score)
	assert_eq(a.lefts, b.lefts)
	assert_eq(a.widths, b.widths)
	assert_eq(a.phase, b.phase)
