class_name PlayResultPanel
extends UIPanel
## Result panel over the fallen tower: the title (`New best!` or `Tower fell`), the score counting up from 0, then the
## best score, perfect drops and best streak rows appearing one after another, and the lobby (left) and play again
## (right, first focus) buttons. Either button works once. A back input goes to the lobby. A run the server did not
## count shows the not recorded line.

@export var title_label: Label
@export var score_caption: Label
@export var score_label: Label
@export var unsaved_label: Label
@export var rows: Array[Control] = []
## Row texts in the order best score, perfect drops, best streak.
@export var row_names: Array[Label] = []
@export var row_values: Array[Label] = []
@export var best_icon: TextureRect
@export var again_button: Button
@export var lobby_button: Button
@export var again_click: UIButton
@export var lobby_click: UIButton

var _param: PlayResultParam = null
var _format_args: FormatArgs = FormatArgs.new()
var _chosen: bool = false
var _receiver: Callable = Callable()


func accepts_param(param: UIParam) -> bool:
	return param is PlayResultParam


func prepare(_reason: UICore.PanelOpenReason, _cache: UIPanelCache) -> bool:
	_param = panel_param as PlayResultParam
	_receiver = _on_count
	LocalizationCore.bind_text(title_label, ReservedString.result_title_best() if _param.new_best else ReservedString.result_title())
	LocalizationCore.bind_text(score_caption, ReservedString.result_score())
	LocalizationCore.bind_text(unsaved_label, ReservedString.result_unsaved())
	LocalizationCore.bind_text(again_button, ReservedString.result_again())
	LocalizationCore.bind_text(lobby_button, ReservedString.result_lobby())
	var names: PackedStringArray = PackedStringArray([ReservedString.result_best(), ReservedString.result_perfects(),
			ReservedString.result_streak()])
	var values: PackedInt64Array = PackedInt64Array([_param.best, _param.perfects, _param.best_streak])
	for i: int in row_names.size():
		LocalizationCore.bind_text(row_names[i], names[i])
		row_values[i].text = _number(values[i])
	if ResourceCore.is_loaded(ResourceKey.ICON__BEST, ResourceCore.BaseKind.TEXTURE_2D):
		best_icon.texture = ResourceCore.get_loaded(ResourceKey.ICON__BEST, ResourceCore.BaseKind.TEXTURE_2D, scope) as Texture2D
	unsaved_label.visible = not _param.saved
	score_label.text = _number(0)
	again_click.set_on_click(_on_again)
	lobby_click.set_on_click(_on_lobby)
	return true


func on_opened(_reason: UICore.PanelOpenReason) -> void:
	var count: TweenDefinition = ResourceCore.get_loaded(ResourceKey.TWEEN__PLAY__COUNT_UP, TweenCore.get_preset_kind(), scope) as TweenDefinition
	if count != null and _param.score > 0:
		TweenCore.play_value(TweenCore.TweenValueKind.FLOAT, Vector4.ZERO, Vector4(float(_param.score), 0.0, 0.0, 0.0), count, _receiver)
	else:
		score_label.text = _number(_param.score)
	var keys: PackedStringArray = PackedStringArray([ResourceKey.TWEEN__PLAY__ROW_IN_1, ResourceKey.TWEEN__PLAY__ROW_IN_2,
			ResourceKey.TWEEN__PLAY__ROW_IN_3])
	for i: int in mini(rows.size(), keys.size()):
		rows[i].pivot_offset = rows[i].size * 0.5
		TweenCore.play_preset(keys[i], scope, rows[i])


func on_back() -> void:
	_on_lobby()


func _on_count(value: float) -> void:
	score_label.text = _number(roundi(value))


func _number(value: int) -> String:
	_format_args.clear()
	_format_args.set_int("value", value)
	return LocalizationCore.format(ReservedString.common_number(), _format_args)


func _on_again() -> void:
	if _chosen:
		return
	_chosen = true
	_param.on_again.call()


func _on_lobby() -> void:
	if _chosen:
		return
	_chosen = true
	_param.on_lobby.call()
