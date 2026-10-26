class_name PlayBlock
extends PoolObject
## One block of the tower: the block art tinted with its palette color, drawn at twice its size and scaled by half so
## the bevel stays thin. The root is the bottom center of the block; `visual` is the pivot of the landing squash and
## `glow` the white overlay of a perfect drop.

@export var visual: Node2D
@export var face: NinePatchRect
@export var glow: NinePatchRect

var _land_handle: int = 0
var _glow_handle: int = 0
var _options: TweenOptions = null


func on_borrow() -> void:
	_land_handle = 0
	_glow_handle = 0


func on_return() -> void:
	_stop_tweens()
	visual.scale = Vector2.ONE
	glow.visible = false


## Places the block with its left edge `left`, its width and height in game coordinates, its bottom at `bottom`.
func place(left: int, width: int, height: int, bottom: float, color: Color) -> void:
	var root: Node2D = self as Node as Node2D
	root.position = Vector2(float(left) + float(width) * 0.5, bottom)
	_shape(face, width, height)
	_shape(glow, width, height)
	face.self_modulate = color


## The landing squash on game time, and the white glow of a perfect drop.
func play_land(perfect: bool) -> void:
	_stop_tweens()
	var options: TweenOptions = _game_time()
	_land_handle = TweenCore.play_preset(ResourceKey.TWEEN__PLAY__LAND, SceneCore.current_scope(), visual, options)
	if perfect:
		glow.visible = true
		glow.pivot_offset = glow.size * 0.5
		_glow_handle = TweenCore.play_preset(ResourceKey.TWEEN__PLAY__PERFECT_GLOW, SceneCore.current_scope(), glow, options)


func _shape(rect: NinePatchRect, width: int, height: int) -> void:
	rect.size = Vector2(float(width), float(height)) * PlayConstants.FACE_SCALE
	rect.position = Vector2(-float(width) * 0.5, -float(height))


func _game_time() -> TweenOptions:
	if _options == null:
		_options = TweenOptions.new()
		_options.time_basis = TweenCore.TimeBasis.GAME_TIME
	return _options


func _stop_tweens() -> void:
	if _land_handle != 0:
		TweenCore.stop(_land_handle)
	if _glow_handle != 0:
		TweenCore.stop(_glow_handle)
	_land_handle = 0
	_glow_handle = 0
