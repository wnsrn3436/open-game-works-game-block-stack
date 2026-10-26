class_name LobbyOptionPanel
extends UIPanel
## Option panel over the lobby: music and sound effect toggles; the user code and its copy, the account deletion code
## and withdrawal; the terms and privacy documents and the licenses. The game settings choose no social login adapter
## in any environment and turn privacy choices off, so the panel has no account link and no privacy choice entry. The
## async flows run in static functions that check the panel is still there after each wait, so a closed panel never
## resumes.

@export var title_label: Label
@export var sound_header: Label
@export var music_toggle: CheckBox
@export var sounds_toggle: CheckBox
@export var account_header: Label
@export var user_code_label: Label
@export var copy_user_code_button: Button
@export var deletion_button: Button
@export var deletion_label: Label
@export var copy_code_button: Button
@export var copy_url_button: Button
@export var withdraw_button: Button
@export var legal_header: Label
@export var terms_button: Button
@export var privacy_button: Button
@export var licenses_button: Button
@export var close_button: Button
@export var music_click: UIButton
@export var sounds_click: UIButton
@export var copy_user_code_click: UIButton
@export var deletion_click: UIButton
@export var copy_code_click: UIButton
@export var copy_url_click: UIButton
@export var withdraw_click: UIButton
@export var terms_click: UIButton
@export var privacy_click: UIButton
@export var licenses_click: UIButton
@export var close_click: UIButton

var _format_args: FormatArgs = FormatArgs.new()
var _deletion: DeletionCodeResult = null


func prepare(_reason: UICore.PanelOpenReason, _cache: UIPanelCache) -> bool:
	LocalizationCore.bind_text(title_label, ReservedString.option_title())
	LocalizationCore.bind_text(sound_header, ReservedString.option_sound_header())
	LocalizationCore.bind_text(music_toggle, ReservedString.option_music())
	LocalizationCore.bind_text(sounds_toggle, ReservedString.option_sounds())
	LocalizationCore.bind_text(account_header, ReservedString.option_account_header())
	LocalizationCore.bind_text(copy_user_code_button, ReservedString.option_copy_user_code())
	LocalizationCore.bind_text(deletion_button, ReservedString.option_deletion_issue())
	LocalizationCore.bind_text(copy_code_button, ReservedString.option_copy_code())
	LocalizationCore.bind_text(copy_url_button, ReservedString.option_copy_url())
	LocalizationCore.bind_text(withdraw_button, ReservedString.option_withdraw())
	LocalizationCore.bind_text(legal_header, ReservedString.option_legal_header())
	LocalizationCore.bind_text(terms_button, ReservedString.option_terms())
	LocalizationCore.bind_text(privacy_button, ReservedString.option_privacy())
	LocalizationCore.bind_text(licenses_button, ReservedString.option_licenses())
	LocalizationCore.bind_text(close_button, ReservedString.option_close())
	music_toggle.set_pressed_no_signal(not SoundCore.get_mute(SoundCore.SoundBus.BGM))
	sounds_toggle.set_pressed_no_signal(not SoundCore.get_mute(SoundCore.SoundBus.SFX))
	music_click.set_on_click(_on_music)
	sounds_click.set_on_click(_on_sounds)
	copy_user_code_click.set_on_click(_on_copy_user_code)
	deletion_click.set_on_click(_on_deletion)
	copy_code_click.set_on_click(_on_copy_code)
	copy_url_click.set_on_click(_on_copy_url)
	withdraw_click.set_on_click(_on_withdraw)
	terms_click.set_on_click(_on_terms)
	privacy_click.set_on_click(_on_privacy)
	licenses_click.set_on_click(_on_licenses)
	close_click.set_on_click(_on_close)
	_write_texts()
	return true


## The user code in two groups of 4 characters joined with `-`.
static func user_code() -> String:
	var code: String = AuthCore.get_public_code()
	var half: int = UtilCore.floor_div(code.length(), 2)
	return code.substr(0, half) + LobbyConstants.CODE_JOINER + code.substr(half)


## Writes the formatted texts: the user code and the deletion code.
func _write_texts() -> void:
	_format_args.clear()
	_format_args.set_string("code", LobbyOptionPanel.user_code())
	user_code_label.text = LocalizationCore.format(ReservedString.option_user_code(), _format_args)
	var has_code: bool = _deletion != null and _deletion.ok
	deletion_label.visible = has_code
	copy_code_button.visible = has_code
	copy_url_button.visible = has_code
	if has_code:
		_format_args.clear()
		_format_args.set_string("code", _deletion.code)
		_format_args.set_int("expires_at", _deletion.expires_at)
		_format_args.set_string("url", _deletion.url)
		deletion_label.text = LocalizationCore.format(ReservedString.option_deletion_info(), _format_args)


## The toggle shows the state after the press; music and sound effects follow it.
func _on_music() -> void:
	SoundCore.set_mute(SoundCore.SoundBus.BGM, not music_toggle.button_pressed)


func _on_sounds() -> void:
	SoundCore.set_mute(SoundCore.SoundBus.SFX, not sounds_toggle.button_pressed)
	SoundCore.set_mute(SoundCore.SoundBus.UI, not sounds_toggle.button_pressed)


func _on_copy_user_code() -> void:
	_show_copied(NativeUiCore.copy_text(LobbyOptionPanel.user_code()))


func _on_terms() -> void:
	_open_document(CoreContract.TermsItem.TERMS_ITEM_TERMS)


func _on_privacy() -> void:
	_open_document(CoreContract.TermsItem.TERMS_ITEM_PRIVACY)


func _on_licenses() -> void:
	_open_licenses()


func _on_copy_code() -> void:
	if _deletion != null:
		_show_copied(NativeUiCore.copy_text(_deletion.code))


func _on_copy_url() -> void:
	if _deletion != null:
		_show_copied(NativeUiCore.copy_text(_deletion.url))


func _show_copied(ok: bool) -> void:
	MessageCore.show_toast(ReservedString.option_copied() if ok else ReservedString.option_failed())


func _on_deletion() -> void:
	_issue_deletion_code(self)


func _on_withdraw() -> void:
	var param: SystemPopupParam = SystemPopupParam.new()
	param.body = ReservedString.option_withdraw_confirm()
	param.buttons = [_popup_button(ReservedString.option_cancel(), Callable()), _popup_button(ReservedString.option_withdraw_ok(), _withdraw)]
	param.back_button = 0
	UICore.open_system_popup(param, Callable())


func _on_close() -> void:
	UICore.close_panel()


static func _popup_button(label: String, callback: Callable) -> SystemPopupButton:
	var button: SystemPopupButton = SystemPopupButton.new()
	button.label = label
	button.callback = callback
	return button


static func _open_document(item: CoreContract.TermsItem) -> void:
	if not await AuthCore.open_terms_document(item):
		MessageCore.show_toast(ReservedString.option_failed())


static func _open_licenses() -> void:
	if not await UICore.open_licenses():
		MessageCore.show_toast(ReservedString.option_failed())


## Withdraws after the confirm popup. On success `AuthCore` restarts the game.
static func _withdraw() -> void:
	if not await AuthCore.withdraw():
		MessageCore.show_toast(ReservedString.option_failed())


static func _issue_deletion_code(panel: LobbyOptionPanel) -> void:
	var result: DeletionCodeResult = await AuthCore.issue_deletion_code()
	if not result.ok:
		MessageCore.show_toast(ReservedString.option_failed())
		return
	if is_instance_valid(panel):
		panel._deletion = result
		panel._write_texts()
