class_name LobbyPanel
extends UIPanel
## Root panel of the lobby: the game name and the record line at the top, the best score plate at the top right,
## `Options` at the top left, the demo tower in the middle with one block sliding on top, and the large `Play` at the
## bottom center (first focus, breathing). Pressing `Play` twice changes the scene once.

@export var title_label: Label
@export var record_label: Label
@export var best_caption: Label
@export var best_label: Label
@export var best_icon: TextureRect
@export var play_button: Button
@export var option_button: Button
@export var play_click: UIButton
@export var option_click: UIButton
@export var demo_blocks: Array[NinePatchRect] = []
@export var demo_slider: Control

var _format_args: FormatArgs = FormatArgs.new()
var _starting: bool = false


func prepare(_reason: UICore.PanelOpenReason, _cache: UIPanelCache) -> bool:
	LocalizationCore.bind_text(title_label, ReservedString.app_name())
	LocalizationCore.bind_text(best_caption, ReservedString.lobby_best())
	LocalizationCore.bind_text(play_button, ReservedString.lobby_play())
	LocalizationCore.bind_text(option_button, ReservedString.lobby_options())
	play_click.set_on_click(_on_play)
	option_click.set_on_click(_on_option)
	if ResourceCore.is_loaded(ResourceKey.ICON__BEST, ResourceCore.BaseKind.TEXTURE_2D):
		best_icon.texture = ResourceCore.get_loaded(ResourceKey.ICON__BEST, ResourceCore.BaseKind.TEXTURE_2D, scope) as Texture2D
	for i: int in demo_blocks.size():
		demo_blocks[i].self_modulate = CommonBlockColor.of_level(i + 1)
	EventCore.subscribe(UserStateChangedEvent, _on_user_state_changed)
	_write()
	return true


func on_opened(_reason: UICore.PanelOpenReason) -> void:
	play_button.pivot_offset = play_button.size * 0.5
	TweenCore.play_preset(ResourceKey.TWEEN__LOBBY__PLAY_PULSE, scope, play_button)
	TweenCore.play_preset(ResourceKey.TWEEN__LOBBY__DEMO_SLIDE, scope, demo_slider)


func _exit_tree() -> void:
	EventCore.unsubscribe_all(self)


func _on_play() -> void:
	if _starting:
		return
	_starting = true
	SceneCore.change_scene(ResourceKey.SCENE__PLAY__PLAY, null)


func _on_option() -> void:
	UICore.open_panel(ResourceKey.PREFAB__LOBBY__OPTION_PANEL, null, false)


func _on_user_state_changed(_event: UserStateChangedEvent) -> void:
	_write()


func _write() -> void:
	_format_args.clear()
	_format_args.set_int("value", CommonRecord.best_score())
	best_label.text = LocalizationCore.format(ReservedString.common_number(), _format_args)
	var runs: int = CommonRecord.runs()
	if runs == 0:
		record_label.text = LocalizationCore.get_text(ReservedString.lobby_first_run())
		return
	_format_args.clear()
	_format_args.set_int("runs", runs)
	_format_args.set_int("streak", CommonRecord.best_streak())
	record_label.text = LocalizationCore.format(ReservedString.lobby_record(), _format_args)
