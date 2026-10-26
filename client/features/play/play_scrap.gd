class_name PlayScrap
extends PoolObject
## A falling piece: the overhang cut off by a drop, or the whole block that missed. The root is the center of the
## piece; `mirror` turns the fall to the left for a piece on the left side; `fall` drops, spins and fades with
## `tween/play/cut_fall` on game time, and the piece goes back to the pool when the tween ends.

@export var mirror: Node2D
@export var fall: Node2D
@export var face: NinePatchRect

var _options: TweenOptions = null
var _handle: int = 0


func on_borrow() -> void:
	_handle = 0


func on_return() -> void:
	var handle: int = _handle
	_handle = 0
	if handle != 0:
		TweenCore.stop(handle)
	fall.position = Vector2.ZERO
	fall.rotation = 0.0
	fall.modulate.a = 1.0


## Starts the fall of the piece with left edge `left`, `width`, `height` and bottom `bottom`; `to_left` falls to the
## left of the tower.
func play(left: int, width: int, height: int, bottom: float, color: Color, to_left: bool) -> void:
	if _options == null:
		_options = TweenOptions.new()
		_options.time_basis = TweenCore.TimeBasis.GAME_TIME
		_options.callback = _on_end
	var root: Node2D = self as Node as Node2D
	root.position = Vector2(float(left) + float(width) * 0.5, bottom - float(height) * 0.5)
	mirror.scale = Vector2(-1.0 if to_left else 1.0, 1.0)
	face.size = Vector2(float(width), float(height)) * PlayConstants.FACE_SCALE
	face.position = Vector2(-float(width), -float(height)) * 0.5
	face.self_modulate = color
	_handle = TweenCore.play_preset(ResourceKey.TWEEN__PLAY__CUT_FALL, SceneCore.current_scope(), fall, _options)
	if _handle == 0:
		PoolCore.notify_finished(self)


func _on_end(reason: TweenCore.TweenEndReason) -> void:
	if _handle != 0 and reason == TweenCore.TweenEndReason.COMPLETED:
		_handle = 0
		PoolCore.notify_finished(self)
