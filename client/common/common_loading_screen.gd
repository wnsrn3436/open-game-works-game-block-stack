class_name CommonLoadingScreen
extends LoadingScreenBase
## Loading screen of every scene transition: the loading text over a bar of block art that fills with the progress.

@export var label: Label
@export var bar_fill: Control
@export var bar_track: Control


func _ready() -> void:
	LocalizationCore.bind_text(label, ReservedString.loading_text())
	on_progress(0)


func on_progress(progress_permille: int) -> void:
	var share: float = float(clampi(progress_permille, 0, CommonConstants.PERMILLE)) / CommonConstants.PERMILLE_F
	bar_fill.size.x = bar_track.size.x * share
