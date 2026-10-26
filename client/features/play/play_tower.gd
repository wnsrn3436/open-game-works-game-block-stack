class_name PlayTower
extends RefCounted
## The tower of one run in integer game coordinates: x is relative to the tower axis, a block is its left edge and
## width. The base slab is level 0. A block slides at the next level with the width of the top block, from the left at
## odd levels and from the right at even levels, and `drop` places it. Time is game ms given to `advance`.

enum Phase { SLIDING, WAITING, FALLEN }
enum Drop { NONE, PERFECT, TRIM, MISS }

## Left edge and width of each level of the tower, the base slab first.
var lefts: PackedInt32Array = PackedInt32Array()
var widths: PackedInt32Array = PackedInt32Array()
var phase: Phase = Phase.WAITING
## Game ms since the run started.
var time_ms: int = 0
var score: int = 0
var perfects: int = 0
var streak: int = 0
var best_streak: int = 0
## Left edge and width of the sliding block; the missed block after a miss.
var moving_left: int = 0
var moving_width: int = 0
## 1 for a block that comes from the left, -1 from the right.
var moving_dir: int = 1
## What the last `drop` did, and its pieces: the placed block, the cut piece (width 0 when none) and the width it grew.
var last_drop: Drop = Drop.NONE
var last_bonus: int = 0
var cut_left: int = 0
var cut_width: int = 0
var grew: int = 0

var _spawn_at: int = 0
var _block_width: int = 0
var _half_range: int = 0
var _speed: int = 0
var _speed_step: int = 0
var _speed_max: int = 0
var _tolerance: int = 0
var _regrow_streak: int = 0
var _regrow_amount: int = 0
var _bonus_max: int = 0
var _next_delay: int = 0


func _init() -> void:
	_block_width = GameSetting.block_width()
	_half_range = GameSetting.slide_half_range()
	_speed = GameSetting.slide_speed()
	_speed_step = GameSetting.slide_speed_step()
	_speed_max = GameSetting.slide_speed_max()
	_tolerance = GameSetting.perfect_tolerance()
	_regrow_streak = GameSetting.regrow_streak()
	_regrow_amount = GameSetting.regrow_amount()
	_bonus_max = GameSetting.perfect_bonus_max()
	_next_delay = GameSetting.next_block_delay()
	lefts.append(-UtilCore.floor_div(_block_width, 2))
	widths.append(_block_width)
	_spawn(0)


## Placed blocks, the base slab not counted.
func blocks() -> int:
	return lefts.size() - 1


func top_left() -> int:
	return lefts[lefts.size() - 1]


func top_width() -> int:
	return widths[widths.size() - 1]


## Slide speed of the block that slides now, in units per second.
func speed() -> int:
	return mini(_speed + blocks() * _speed_step, _speed_max)


## Offset of the sliding block's left edge from the top block's left edge.
func offset() -> int:
	return moving_left - top_left()


func perfect_tolerance() -> int:
	return _tolerance


## Game ms the sliding block has slid; 0 while no block slides.
func slide_elapsed() -> int:
	return maxi(time_ms - _spawn_at, 0) if phase == Phase.SLIDING else 0


## Advances game time by `ms`: the sliding block moves, and the next block appears once the wait after a drop ends.
func advance(ms: int) -> void:
	if phase == Phase.FALLEN or ms <= 0:
		return
	time_ms += ms
	if phase == Phase.WAITING and time_ms >= _spawn_at:
		phase = Phase.SLIDING
	if phase == Phase.SLIDING:
		moving_left = top_left() + offset_at(time_ms - _spawn_at)


## Offset from the top block's left edge after `elapsed_ms` of sliding (the ping-pong of `design.md` `### tower`).
func offset_at(elapsed_ms: int) -> int:
	var span: int = _half_range * 2
	var distance: int = UtilCore.floor_div(speed() * maxi(elapsed_ms, 0), PlayConstants.MS_PER_SECOND)
	var along: int = UtilCore.floor_mod(distance, span * 2)
	var travelled: int = along if along <= span else span * 2 - along
	return (travelled - _half_range) * moving_dir


## Drops the sliding block. `NONE` when no block slides.
func drop() -> Drop:
	if phase != Phase.SLIDING:
		return Drop.NONE
	var off: int = offset()
	var width: int = moving_width
	var gap: int = absi(off)
	cut_left = 0
	cut_width = 0
	grew = 0
	last_bonus = 0
	if gap >= width:
		last_drop = Drop.MISS
		phase = Phase.FALLEN
		streak = 0
		return last_drop
	var left: int = moving_left
	if gap <= _tolerance:
		last_drop = Drop.PERFECT
		left = top_left()
		streak += 1
		best_streak = maxi(best_streak, streak)
		perfects += 1
		last_bonus = mini(streak, _bonus_max)
		if streak >= _regrow_streak:
			grew = mini(_regrow_amount, _block_width - width)
			left -= UtilCore.floor_div(grew, 2)
			width += grew
	else:
		last_drop = Drop.TRIM
		streak = 0
		width -= gap
		if off > 0:
			cut_left = top_left() + top_width()
		else:
			cut_left = moving_left
			left = top_left()
		cut_width = gap
	score += 1 + last_bonus
	lefts.append(left)
	widths.append(width)
	_spawn(time_ms + _next_delay)
	return last_drop


## The sliding block of the next level appears at `at` from the side of that level.
func _spawn(at: int) -> void:
	_spawn_at = at
	phase = Phase.WAITING
	moving_width = top_width()
	moving_dir = 1 if UtilCore.floor_mod(blocks(), 2) == 0 else -1
	moving_left = top_left() + offset_at(0)
	if time_ms >= _spawn_at:
		phase = Phase.SLIDING
