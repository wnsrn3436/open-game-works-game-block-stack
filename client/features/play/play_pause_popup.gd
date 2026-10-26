class_name PlayPausePopup
extends UIPopup
## Pause popup over the run: resume, or end the run now with the score so far. A back input resumes.

@export var title_label: Label
@export var resume_button: Button
@export var end_button: Button
@export var resume_click: UIButton
@export var end_click: UIButton

var _param: PlayPauseParam = null


func accepts_param(param: UIParam) -> bool:
	return param is PlayPauseParam


func prepare() -> bool:
	_param = popup_param as PlayPauseParam
	LocalizationCore.bind_text(title_label, ReservedString.pause_title())
	LocalizationCore.bind_text(resume_button, ReservedString.pause_resume())
	LocalizationCore.bind_text(end_button, ReservedString.pause_end())
	resume_click.set_on_click(_on_resume)
	end_click.set_on_click(_on_end)
	return true


func on_back() -> void:
	_on_resume()


func _on_resume() -> void:
	UICore.close_popup(self, _param.on_resume)


func _on_end() -> void:
	UICore.close_popup(self, _param.on_end)
