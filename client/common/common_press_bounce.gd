class_name CommonPressBounce
extends Node
## Press bounce of a button: a child of the button that plays `tween/common/button_press` on it each time it is pressed
## down, so every button answers a press at once with a small scale bounce. The click sound is `[ui_button_click]`,
## which `UIButton` plays.

var _button: BaseButton = null


func _ready() -> void:
	_button = get_parent() as BaseButton
	if _button != null:
		_button.button_down.connect(_on_down)


func _on_down() -> void:
	if _button == null or _button.disabled:
		return
	_button.pivot_offset = _button.size * 0.5
	TweenCore.play_preset(ResourceKey.TWEEN__COMMON__BUTTON_PRESS, ResourceCore.get_global_scope(), _button)
