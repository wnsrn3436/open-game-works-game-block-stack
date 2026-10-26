class_name CommonLoadingIcon
extends Control
## Loading icon of `UICore`: a small block that turns on `tween/common/loading_spin` while it is shown.

@export var block: Control


func _ready() -> void:
	block.pivot_offset = block.size * 0.5
	TweenCore.play_preset(ResourceKey.TWEEN__COMMON__LOADING_SPIN, ResourceCore.get_global_scope(), block)
