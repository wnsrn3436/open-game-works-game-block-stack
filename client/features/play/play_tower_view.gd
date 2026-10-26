class_name PlayTowerView
extends Node2D
## Draws a `PlayTower`: the base slab, a pooled `PlayBlock` per placed level (the lowest go back to the pool once more
## than `PlayConstants.SHOWN_LEVELS` are placed), the sliding block, the falling pieces and the sky tint. The tower
## scrolls with `tween/play/tower_scroll` so the sliding level stays at `PlayConstants.FOCUS_TOP_Y` once it is high.

@export var slab: NinePatchRect
@export var moving: PlayBlock
@export var sky: CanvasItem

var _scope: Scope = null
var _handles: Array[Vector4i] = []
var _first_shown: int = 0
var _height: int = 0
var _scroll_target: float = 0.0
var _scroll_definition: TweenDefinition = null
var _scroll_options: TweenOptions = null
var _shown_level: int = -1


## Prepares the view for one run in the scene `scope`.
func setup(scope: Scope) -> void:
	_scope = scope
	_height = GameSetting.block_height()
	_scroll_definition = TweenDefinition.new()
	_scroll_options = TweenOptions.new()
	_scroll_options.time_basis = TweenCore.TimeBasis.GAME_TIME
	var width: int = GameSetting.block_width()
	slab.size = Vector2(float(width), float(slab.size.y)) * Vector2(PlayConstants.FACE_SCALE, 1.0)
	slab.position = Vector2(-float(width) * 0.5, 0.0)
	position = Vector2(position.x, PlayConstants.BASE_TOP_Y)
	(moving as Node as Node2D).visible = false


## Bottom y of a tower level in the view, the base slab top being 0.
func level_bottom(level: int) -> float:
	return -float((level - 1) * _height)


## Draws the sliding block where the tower puts it; hidden while no block slides.
func draw_moving(tower: PlayTower) -> void:
	var sliding: bool = tower.phase == PlayTower.Phase.SLIDING
	(moving as Node as Node2D).visible = sliding
	if sliding:
		var level: int = tower.blocks() + 1
		moving.place(tower.moving_left, tower.moving_width, _height, level_bottom(level), CommonBlockColor.of_level(level))
	_tint_sky(tower.blocks())


## Draws the result of a drop: the placed block lands, the cut piece falls; for a miss the whole block falls.
func draw_drop(tower: PlayTower) -> void:
	var level: int = tower.blocks()
	if tower.last_drop == PlayTower.Drop.MISS:
		var miss_level: int = level + 1
		var to_left: bool = tower.offset() < 0
		_fall(tower.moving_left, tower.moving_width, level_bottom(miss_level), CommonBlockColor.of_level(miss_level), to_left)
		(moving as Node as Node2D).visible = false
		return
	var block: PlayBlock = _borrow_block()
	if block == null:
		return
	var color: Color = CommonBlockColor.of_level(level)
	block.place(tower.top_left(), tower.top_width(), _height, level_bottom(level), color)
	block.play_land(tower.last_drop == PlayTower.Drop.PERFECT)
	if tower.cut_width > 0:
		_fall(tower.cut_left, tower.cut_width, level_bottom(level), color, tower.cut_left < tower.top_left())
	(moving as Node as Node2D).visible = false
	_scroll_to(level + 1)


func _borrow_block() -> PlayBlock:
	var handle: Vector4i = PoolCore.borrow(ResourceKey.PREFAB__PLAY__BLOCK, _scope)
	var node: Node = PoolCore.get_instance(handle)
	if node == null:
		return null
	add_child(node)
	move_child(node, slab.get_index() + 1)
	_handles.append(handle)
	if _handles.size() - _first_shown > PlayConstants.SHOWN_LEVELS:
		PoolCore.give_back(_handles[_first_shown])
		_first_shown += 1
	(node as Node2D).visible = true
	return node as PlayBlock


func _fall(left: int, width: int, bottom: float, color: Color, to_left: bool) -> void:
	var handle: Vector4i = PoolCore.borrow(ResourceKey.PREFAB__PLAY__SCRAP, _scope)
	var node: Node = PoolCore.get_instance(handle)
	if node == null:
		return
	add_child(node)
	(node as PlayScrap).play(left, width, _height, bottom, color, to_left)


## Scrolls so the top of the sliding `level` is at `PlayConstants.FOCUS_TOP_Y` once it would be above it.
func _scroll_to(level: int) -> void:
	var top: float = PlayConstants.BASE_TOP_Y - float(level * _height)
	var target: float = PlayConstants.BASE_TOP_Y + maxf(0.0, PlayConstants.FOCUS_TOP_Y - top)
	if is_equal_approx(target, _scroll_target):
		return
	_scroll_target = target
	var preset: TweenDefinition = ResourceCore.get_loaded(ResourceKey.TWEEN__PLAY__TOWER_SCROLL, TweenCore.get_preset_kind(), _scope) as TweenDefinition
	if preset == null or not TweenCore.copy_definition(preset, _scroll_definition) or _scroll_definition.steps.is_empty():
		position = Vector2(position.x, target)
		return
	for change: TweenChange in _scroll_definition.steps[0].changes:
		if change.property == TweenCore.TweenProperty.POSITION:
			change.target_value = Vector4(position.x, target, 0.0, 0.0)
	TweenCore.play(_scroll_definition, self, _scroll_options)


## Tints the sky toward dusk and night as the tower rises.
func _tint_sky(level: int) -> void:
	if level == _shown_level:
		return
	_shown_level = level
	var levels: PackedInt32Array = PlayConstants.SKY_LEVELS
	var tints: PackedColorArray = PlayConstants.SKY_TINTS
	var color: Color = tints[tints.size() - 1]
	for i: int in range(levels.size() - 1):
		if level < levels[i + 1]:
			var part: float = float(level - levels[i]) / float(levels[i + 1] - levels[i])
			color = tints[i].lerp(tints[i + 1], part)
			break
	sky.self_modulate = color
