class_name PlayHudPanel
extends UIPanel
## Root panel of the run: the score at the top center, the streak badge under it, the best score plate at the top
## right, `Getting ready` until the server starts the run and the drop hint at the bottom on the first run. It draws
## `PlayStateChangedEvent` and pops the score on every drop and the badge on every perfect drop. It takes no pointer
## input, so a click anywhere drops the block; a back input asks the run for the pause popup.

@export var score_label: Label
@export var streak_label: Label
@export var best_caption: Label
@export var best_label: Label
@export var best_icon: TextureRect
@export var ready_label: Label
@export var hint_label: Label

var _format_args: FormatArgs = FormatArgs.new()
var _options: TweenOptions = null
var _shown_score: int = -1
var _shown_best: int = -1


func prepare(_reason: UICore.PanelOpenReason, _cache: UIPanelCache) -> bool:
	LocalizationCore.bind_text(best_caption, ReservedString.play_best())
	LocalizationCore.bind_text(ready_label, ReservedString.play_ready())
	if ResourceCore.is_loaded(ResourceKey.ICON__BEST, ResourceCore.BaseKind.TEXTURE_2D):
		best_icon.texture = ResourceCore.get_loaded(ResourceKey.ICON__BEST, ResourceCore.BaseKind.TEXTURE_2D, scope) as Texture2D
	_options = TweenOptions.new()
	_options.time_basis = TweenCore.TimeBasis.GAME_TIME
	streak_label.visible = false
	hint_label.visible = false
	EventCore.subscribe(PlayStateChangedEvent, _on_state_changed)
	EventCore.subscribe(InputPromptChangedEvent, _on_prompt_changed)
	EventCore.subscribe(InputDeviceChangedEvent, _on_device_changed)
	_write_hint()
	return true


func on_back() -> void:
	EventCore.publish(EventCore.acquire(PlayPauseRequestedEvent))


func _exit_tree() -> void:
	EventCore.unsubscribe_all(self)


func _on_state_changed(event: PlayStateChangedEvent) -> void:
	ready_label.visible = event.starting
	hint_label.visible = event.show_hint and not event.starting
	if event.score != _shown_score:
		_shown_score = event.score
		score_label.text = _number(event.score)
		if event.drop != PlayTower.Drop.NONE:
			score_label.pivot_offset = score_label.size * 0.5
			TweenCore.play_preset(ResourceKey.TWEEN__PLAY__SCORE_POP, scope, score_label, _options)
	var best: int = maxi(event.best, event.score)
	if best != _shown_best:
		_shown_best = best
		best_label.text = _number(best)
	if event.drop == PlayTower.Drop.PERFECT:
		_show_streak(event.streak, event.grew)
	elif event.drop != PlayTower.Drop.NONE:
		TweenCore.stop_target(streak_label)
		streak_label.visible = false


func _show_streak(streak: int, grew: bool) -> void:
	_format_args.clear()
	_format_args.set_int("streak", streak)
	var key: String = ReservedString.play_perfect_grow() if grew else ReservedString.play_perfect()
	streak_label.text = LocalizationCore.format(key, _format_args)
	streak_label.visible = true
	streak_label.pivot_offset = streak_label.size * 0.5
	TweenCore.play_preset(ResourceKey.TWEEN__PLAY__STREAK_POP, scope, streak_label, _options)


func _number(value: int) -> String:
	_format_args.clear()
	_format_args.set_int("value", value)
	return LocalizationCore.format(ReservedString.common_number(), _format_args)


func _on_prompt_changed(_event: InputPromptChangedEvent) -> void:
	_write_hint()


func _on_device_changed(_event: InputDeviceChangedEvent) -> void:
	_write_hint()


func _write_hint() -> void:
	var key: String = ReservedString.play_hint_pad() if InputCore.get_device() == InputCore.InputDevice.GAMEPAD else ReservedString.play_hint()
	hint_label.text = LocalizationCore.get_text(key)
