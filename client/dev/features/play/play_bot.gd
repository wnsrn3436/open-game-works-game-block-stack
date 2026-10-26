class_name PlayBot
extends RefCounted
## The bot player and the screen commands of the play feature. In the lobby it presses `Play`; in a run it presses
## `Space` when the sliding block is about to line up with the top block, and from `PlayConstants.DEV_BOT_TIRED_BLOCKS` placed blocks on it
## drops at once, so every run ends with a miss; on the result panel it plays again; on the pause popup it resumes.

const _ANCHOR_PLAY: String = "lobby_play"
const _ANCHOR_OPTION_CLOSE: String = "option_close"
const _ANCHOR_RESUME: String = "pause_resume"
const _ANCHOR_AGAIN: String = "result_again"
const _ANCHOR_AGREE_ALL: String = "terms_agree_all"
const _ANCHOR_CONFIRM: String = "terms_confirm"
const _DROP_KEY: String = "Space"

## A miss waits for the next run start to count as a restart.
var _restart_pending: bool = false


## `play.bot_next_input`: the next input command, or `null` while a transition runs or nothing is to be pressed.
func next_input(_args: PackedStringArray) -> RunCommandResult:
	if SceneCore.is_transitioning() or UICore.is_panel_transitioning() or UICore.is_system_popup_visible():
		return _none()
	var popups: PackedStringArray = UICore.get_open_popups()
	if popups.has(ResourceKey.PREFAB__COMMON__TERMS_POPUP):
		var confirm: AnchorResult = UICore.get_anchor_rect(_ANCHOR_CONFIRM)
		var ready_to_confirm: bool = confirm.visible and confirm.element is Button and not (confirm.element as Button).disabled
		return _input("tap_anchor", _ANCHOR_CONFIRM if ready_to_confirm else _ANCHOR_AGREE_ALL)
	var scene: String = SceneCore.current_scene_key()
	var panel: String = UICore.get_current_panel_key()
	if scene == ResourceKey.SCENE__LOBBY__LOBBY:
		if panel == ResourceKey.PREFAB__LOBBY__OPTION_PANEL:
			return _input("tap_anchor", _ANCHOR_OPTION_CLOSE)
		return _input("tap_anchor", _ANCHOR_PLAY) if panel == ResourceKey.PREFAB__LOBBY__LOBBY_PANEL else _none()
	if scene != ResourceKey.SCENE__PLAY__PLAY:
		return _none()
	if popups.has(ResourceKey.PREFAB__PLAY__PAUSE_POPUP):
		return _input("tap_anchor", _ANCHOR_RESUME)
	if panel == ResourceKey.PREFAB__PLAY__RESULT_PANEL:
		return _input("tap_anchor", _ANCHOR_AGAIN)
	var play: PlayScene = find_play_scene()
	if play == null or not play.is_playing() or play.is_paused():
		return _none()
	var tower: PlayTower = play.get_tower()
	if tower.phase != PlayTower.Phase.SLIDING:
		return _none()
	if tower.blocks() >= PlayConstants.DEV_BOT_TIRED_BLOCKS:
		return _input("key", _DROP_KEY)
	var ahead: int = tower.offset_at(tower.slide_elapsed() + PlayConstants.DEV_BOT_LEAD_MS)
	var window: int = maxi(tower.perfect_tolerance(), UtilCore.floor_div(tower.moving_width, PlayConstants.DEV_BOT_WINDOW_DIVISOR))
	return _input("key", _DROP_KEY) if absi(ahead) <= window else _none()


func on_moment(event: PlayMomentEvent) -> void:
	match event.moment:
		PlayMomentEvent.Moment.RESPONSE:
			QACore.mark(QACore.MarkKind.RESPONSE)
		PlayMomentEvent.Moment.PERFECT:
			QACore.mark(QACore.MarkKind.REWARD)
		PlayMomentEvent.Moment.MISS:
			_restart_pending = true
			QACore.mark(QACore.MarkKind.FAIL)
		PlayMomentEvent.Moment.STARTED:
			if _restart_pending:
				_restart_pending = false
				QACore.mark(QACore.MarkKind.RESTART)
		PlayMomentEvent.Moment.RESULT:
			QACore.mark(QACore.MarkKind.GOAL)


## The score is at least 1 per block and at most the block points plus the bonus of the perfects; the top block is
## wider than 0 and at most the start width; the perfects and the streaks fit the blocks.
func tower_in_range() -> bool:
	var tower: PlayTower = _tower()
	if tower == null:
		return true
	var blocks: int = tower.blocks()
	var score_fits: bool = tower.score >= blocks and tower.score - blocks <= tower.perfects * GameSetting.perfect_bonus_max()
	var width_fits: bool = tower.top_width() > 0 and tower.top_width() <= GameSetting.block_width()
	var counts_fit: bool = tower.perfects <= blocks and tower.best_streak <= tower.perfects and tower.streak <= tower.best_streak
	return score_fits and width_fits and counts_fit


## The run on screen as a JSON object, or the empty string when no tower is on screen.
func state_of_run() -> String:
	var tower: PlayTower = _tower()
	if tower == null:
		return ""
	var play: PlayScene = find_play_scene()
	return JSON.stringify({
		"playing": play.is_playing(),
		"paused": play.is_paused(),
		"phase": PlayBot._phase_name(tower.phase),
		"offset": tower.offset(),
		"width": tower.moving_width,
		"top_width": tower.top_width(),
		"perfect_tolerance": tower.perfect_tolerance(),
		"speed": tower.speed(),
		"dir": tower.moving_dir,
		"blocks": tower.blocks(),
		"score": tower.score,
		"perfects": tower.perfects,
		"streak": tower.streak,
		"best_streak": tower.best_streak,
	})


## `play.open_play`: a new run with its HUD on top; ends when the run takes drops.
func open_play(_args: PackedStringArray) -> RunCommandResult:
	UICore.close_all_popups()
	if not await SceneCore.change_scene(ResourceKey.SCENE__PLAY__PLAY, null):
		return _result(false, "\"the play scene did not open\"")
	for i: int in PlayConstants.DEV_WAIT_FRAMES:
		var play: PlayScene = find_play_scene()
		if play != null and play.is_playing() and not SceneCore.is_transitioning():
			return _result(true, "")
		await (Engine.get_main_loop() as SceneTree).process_frame
	return _result(false, "\"the run did not start\"")


## `play.open_pause`: a new run with the pause popup open.
func open_pause(args: PackedStringArray) -> RunCommandResult:
	var opened: RunCommandResult = await open_play(args)
	if not opened.ok:
		return opened
	EventCore.publish(EventCore.acquire(PlayPauseRequestedEvent))
	for i: int in PlayConstants.DEV_WAIT_FRAMES:
		if UICore.get_open_popups().has(ResourceKey.PREFAB__PLAY__PAUSE_POPUP) and not UICore.is_flow_in_progress():
			return _result(true, "")
		await (Engine.get_main_loop() as SceneTree).process_frame
	return _result(false, "\"the pause popup did not open\"")


## `play.open_result`: a new run ended at once as `End run` does; ends when the result panel is on top.
func open_result(args: PackedStringArray) -> RunCommandResult:
	var opened: RunCommandResult = await open_play(args)
	if not opened.ok:
		return opened
	find_play_scene().end_run()
	return await _wait_result()


## `play.end_run`: ends the run on screen as `End run` does; ends when the result panel is on top.
func end_run(_args: PackedStringArray) -> RunCommandResult:
	var play: PlayScene = find_play_scene()
	if play == null or not play.is_playing():
		return _result(false, "\"no run takes drops\"")
	play.end_run()
	return await _wait_result()


## `play.state`: the run on screen, or `null` when no tower is on screen.
func state(_args: PackedStringArray) -> RunCommandResult:
	var run: String = state_of_run()
	return _result(true, "null" if run.is_empty() else run)


## The play scene on screen, or `null`.
func find_play_scene() -> PlayScene:
	return PlayBot._find_play((Engine.get_main_loop() as SceneTree).root)


func _tower() -> PlayTower:
	var play: PlayScene = find_play_scene()
	return null if play == null else play.get_tower()


func _wait_result() -> RunCommandResult:
	for i: int in PlayConstants.DEV_WAIT_FRAMES:
		if UICore.get_current_panel_key() == ResourceKey.PREFAB__PLAY__RESULT_PANEL and not UICore.is_panel_transitioning():
			return _result(true, "")
		await (Engine.get_main_loop() as SceneTree).process_frame
	return _result(false, "\"the result panel did not open\"")


static func _phase_name(phase: PlayTower.Phase) -> String:
	match phase:
		PlayTower.Phase.SLIDING:
			return "sliding"
		PlayTower.Phase.WAITING:
			return "waiting"
	return "fallen"


static func _find_play(node: Node) -> PlayScene:
	if node is PlayScene:
		return node as PlayScene
	for child: Node in node.get_children():
		var found: PlayScene = PlayBot._find_play(child)
		if found != null:
			return found
	return null


func _input(command: String, arg: String) -> RunCommandResult:
	return _result(true, JSON.stringify({"command": command, "args": PackedStringArray([arg])}))


func _none() -> RunCommandResult:
	return _result(true, "null")


func _result(ok: bool, result: String) -> RunCommandResult:
	var out: RunCommandResult = RunCommandResult.new()
	out.ok = ok
	out.result = result
	return out
