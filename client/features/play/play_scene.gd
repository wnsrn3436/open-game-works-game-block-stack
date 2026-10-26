class_name PlayScene
extends SceneBase
## One run. It starts a play session on the server, runs a `PlayTower` on game time, drops the sliding block on the
## `drop` action (or the tap of a touch pointer), draws the tower with `PlayTowerView` and plays the landing, perfect
## and miss feedback. After a miss it waits `[fall_wait]` while the block falls, sends the result with
## `FinishPlaySession` and opens the result panel. The HUD is the root panel; it follows `PlayStateChangedEvent`. The
## pause popup holds game time with `TimeCore.set_paused` while it is open.

enum Stage { STARTING, PLAYING, ENDING, SAVING, RESULT, LEAVING }

const _DROP: StringName = &"drop"
const _PAUSE: StringName = &"pause"

@export var view: PlayTowerView
@export var sky: TextureRect

var _stage: Stage = Stage.STARTING
var _tower: PlayTower = null
var _play_session_id: String = ""
var _end_wait_ms: int = 0
var _paused: bool = false
var _tapped: bool = false
var _dropped_once: bool = false
var _best_before: int = 0
var _first_run: bool = false
var _send_finish: Callable = Callable()
var _perfect_flash: TweenDefinition = null
var _fail_flash: TweenDefinition = null


func on_preload(preload_request: PreloadRequest, prefill_items: Array[PrefillItem]) -> void:
	for key: String in [ResourceKey.BACKGROUND__SKY, ResourceKey.NINE_SLICE__BLOCK, ResourceKey.ICON__BEST]:
		preload_request.add_item(key, ResourceCore.BaseKind.TEXTURE_2D)
	for key: String in [ReservedSound.block_place(), ReservedSound.block_perfect(), ReservedSound.block_miss(), ResourceKey.BGM__MAIN]:
		preload_request.add_item(key, ResourceCore.BaseKind.AUDIO_STREAM)
	var tween_kind: int = TweenCore.get_preset_kind()
	for key: String in PlayScene.tween_keys():
		preload_request.add_item(key, tween_kind)
	for key: String in [ResourceKey.PREFAB__PLAY__BLOCK, ResourceKey.PREFAB__PLAY__SCRAP]:
		var item: PrefillItem = PrefillItem.new()
		item.resource_key = key
		item.pool_scope = scope
		prefill_items.append(item)


func on_prepare() -> bool:
	view.setup(scope)
	_send_finish = _finish_run
	return true


func on_start() -> void:
	if ResourceCore.is_loaded(ResourceKey.BACKGROUND__SKY, ResourceCore.BaseKind.TEXTURE_2D):
		sky.texture = ResourceCore.get_loaded(ResourceKey.BACKGROUND__SKY, ResourceCore.BaseKind.TEXTURE_2D, scope) as Texture2D
	var kind: int = TweenCore.get_preset_kind()
	_perfect_flash = ResourceCore.get_loaded(ResourceKey.TWEEN__PLAY__PERFECT_FLASH, kind, scope) as TweenDefinition
	_fail_flash = ResourceCore.get_loaded(ResourceKey.TWEEN__PLAY__FAIL_FLASH, kind, scope) as TweenDefinition
	SoundCore.play_bgm(ResourceKey.BGM__MAIN, scope)
	EventCore.subscribe(PlayPauseRequestedEvent, _on_pause_requested)
	EventCore.subscribe(TapEvent, _on_tap)
	_begin_run()


func on_exit() -> void:
	EventCore.unsubscribe_all(self)
	_set_paused(false)
	GameUpdateCore.set_in_play(false)


## The tower of the run on screen. `null` until the server starts the play session.
func get_tower() -> PlayTower:
	return _tower


## Whether the run takes drops: the server started its play session and no block has missed yet.
func is_playing() -> bool:
	return _stage == Stage.PLAYING


func is_paused() -> bool:
	return _paused


## Tween preset keys the run and its HUD, pause popup and result panel play.
static func tween_keys() -> PackedStringArray:
	return PackedStringArray([
		ResourceKey.TWEEN__PLAY__LAND, ResourceKey.TWEEN__PLAY__PERFECT_GLOW, ResourceKey.TWEEN__PLAY__CUT_FALL,
		ResourceKey.TWEEN__PLAY__TOWER_SCROLL, ResourceKey.TWEEN__PLAY__SCORE_POP, ResourceKey.TWEEN__PLAY__STREAK_POP,
		ResourceKey.TWEEN__PLAY__PERFECT_FLASH, ResourceKey.TWEEN__PLAY__FAIL_FLASH, ResourceKey.TWEEN__PLAY__COUNT_UP,
		ResourceKey.TWEEN__PLAY__ROW_IN_1, ResourceKey.TWEEN__PLAY__ROW_IN_2, ResourceKey.TWEEN__PLAY__ROW_IN_3,
		ResourceKey.TWEEN__COMMON__PANEL_IN, ResourceKey.TWEEN__COMMON__PANEL_OUT])


## Starts the play session of a new run. The run plays once the server answers.
func _begin_run() -> void:
	_stage = Stage.STARTING
	_best_before = CommonRecord.best_score()
	_first_run = CommonRecord.runs() == 0
	_publish_state(PlayTower.Drop.NONE)
	var request: CoreContract.StartPlaySessionRequest = CoreContract.StartPlaySessionRequest.new()
	request.mode_id = ReservedId.run_mode()
	request.level_id = 0
	NetworkCore.send(request, _on_started, _on_start_failed)


func _on_started(response: ContractMessage) -> void:
	var started: CoreContract.StartPlaySessionResponse = response as CoreContract.StartPlaySessionResponse
	if started == null or _stage != Stage.STARTING:
		return
	_play_session_id = started.play_session_id
	_tower = PlayTower.new()
	GameUpdateCore.set_in_play(true)
	_stage = Stage.PLAYING
	view.draw_moving(_tower)
	_publish_state(PlayTower.Drop.NONE)
	_publish_moment(PlayMomentEvent.Moment.STARTED)


func _on_start_failed(_failure: RequestFailure) -> bool:
	if _stage == Stage.STARTING:
		_leave_to_lobby()
	return false


func _process(_delta: float) -> void:
	var tapped: bool = _tapped
	_tapped = false
	if _tower == null or _paused:
		return
	var frame_ms: int = TimeCore.get_game_frame_ms()
	if _stage == Stage.PLAYING:
		if InputCore.is_just_pressed(_PAUSE):
			_open_pause()
			return
		if InputCore.is_just_pressed(_DROP) or tapped:
			_drop()
		if _stage == Stage.PLAYING:
			_tower.advance(frame_ms)
			view.draw_moving(_tower)
	elif _stage == Stage.ENDING:
		_end_wait_ms -= frame_ms
		if _end_wait_ms <= 0:
			_stage = Stage.SAVING
			_send_finish.call_deferred()


## Drops the sliding block where it is on screen and plays the answer of that drop.
func _drop() -> void:
	var drop: PlayTower.Drop = _tower.drop()
	if drop == PlayTower.Drop.NONE:
		return
	_dropped_once = true
	_publish_moment(PlayMomentEvent.Moment.RESPONSE)
	view.draw_drop(_tower)
	match drop:
		PlayTower.Drop.PERFECT:
			_play_sound(ReservedSound.block_perfect())
			_flash(_perfect_flash)
			_publish_moment(PlayMomentEvent.Moment.PERFECT)
		PlayTower.Drop.TRIM:
			_play_sound(ReservedSound.block_place())
		PlayTower.Drop.MISS:
			_play_sound(ReservedSound.block_miss())
			_flash(_fail_flash)
			_stage = Stage.ENDING
			_end_wait_ms = GameSetting.fall_wait()
			_publish_moment(PlayMomentEvent.Moment.MISS)
	_publish_state(drop)


func _on_tap(event: TapEvent) -> void:
	if event.pointer_id != PlayConstants.MOUSE_POINTER_ID:
		_tapped = true


func _play_sound(key: String) -> void:
	SoundCore.play(key, SoundCore.SoundBus.SFX, scope)


func _flash(definition: TweenDefinition) -> void:
	if definition != null:
		ScreenEffectCore.play_preset(ScreenEffectCore.ScreenEffectChannel.WORLD, self, definition, TweenCore.TimeBasis.GAME_TIME)


func _publish_state(drop: PlayTower.Drop) -> void:
	var event: PlayStateChangedEvent = EventCore.acquire(PlayStateChangedEvent) as PlayStateChangedEvent
	event.starting = _tower == null
	event.best = _best_before
	event.drop = drop
	event.show_hint = _first_run and not _dropped_once
	if _tower != null:
		event.score = _tower.score
		event.streak = _tower.streak
		event.grew = drop == PlayTower.Drop.PERFECT and _tower.grew > 0
	EventCore.publish(event)


func _publish_moment(moment: PlayMomentEvent.Moment) -> void:
	var event: PlayMomentEvent = EventCore.acquire(PlayMomentEvent) as PlayMomentEvent
	event.moment = moment
	EventCore.publish(event)


## Sends the finished run. The result panel opens when the server answers, or with the run unsaved when it refuses it.
func _finish_run() -> void:
	if _stage != Stage.SAVING:
		return
	var result: GameContract.PlaySessionResult = GameContract.PlaySessionResult.new()
	result.blocks = _tower.blocks()
	result.score = _tower.score
	result.perfects = _tower.perfects
	result.best_streak = _tower.best_streak
	var request: CoreContract.FinishPlaySessionRequest = CoreContract.FinishPlaySessionRequest.new()
	request.play_session_id = _play_session_id
	request.result = result.encode()
	NetworkCore.send(request, _on_finished, _on_finish_failed)


func _on_finished(_response: ContractMessage) -> void:
	GameUpdateCore.set_in_play(false)
	_show_result(true)


## A play session the server can no longer count (it expired, or the server does not know it) is answered here: the
## result panel says the run was not recorded. Other failures keep the core error handling.
func _on_finish_failed(failure: RequestFailure) -> bool:
	GameUpdateCore.set_in_play(false)
	_show_result(false)
	return PlayScene.is_uncounted(failure)


static func is_uncounted(failure: RequestFailure) -> bool:
	if failure.kind != NetworkCore.FailureKind.SERVER_ERROR:
		return false
	return failure.error_code == CoreContract.CoreError.CORE_ERROR_PLAY_SESSION_EXPIRED \
		or failure.error_code == CoreContract.CoreError.CORE_ERROR_PLAY_SESSION_NOT_FOUND


func _show_result(saved: bool) -> void:
	if _stage != Stage.SAVING:
		return
	_stage = Stage.RESULT
	var param: PlayResultParam = PlayResultParam.new()
	param.score = _tower.score
	param.perfects = _tower.perfects
	param.best_streak = _tower.best_streak
	param.best = CommonRecord.best_score() if saved else _best_before
	param.new_best = _tower.score > _best_before
	param.saved = saved
	param.on_again = _run_again
	param.on_lobby = _leave_to_lobby
	UICore.open_panel(ResourceKey.PREFAB__PLAY__RESULT_PANEL, param, false)
	_publish_moment(PlayMomentEvent.Moment.RESULT)


func _on_pause_requested(_event: PlayPauseRequestedEvent) -> void:
	_open_pause()


## Opens the pause popup while the run takes drops; game time holds until it closes.
func _open_pause() -> void:
	if _stage != Stage.PLAYING or _paused:
		return
	_set_paused(true)
	var param: PlayPauseParam = PlayPauseParam.new()
	param.on_resume = _on_resume
	param.on_end = end_run
	UICore.open_popup(ResourceKey.PREFAB__PLAY__PAUSE_POPUP, param, Callable())


func _on_resume() -> void:
	_set_paused(false)


## `End run`: the run ends as a miss with the score so far.
func end_run() -> void:
	_set_paused(false)
	if _stage != Stage.PLAYING:
		return
	_stage = Stage.SAVING
	_publish_moment(PlayMomentEvent.Moment.MISS)
	_send_finish.call_deferred()


func _set_paused(paused: bool) -> void:
	if paused == _paused:
		return
	_paused = paused
	TimeCore.set_paused(paused)


func _run_again() -> void:
	if _stage == Stage.LEAVING:
		return
	_stage = Stage.LEAVING
	SceneCore.change_scene(ResourceKey.SCENE__PLAY__PLAY, null)


func _leave_to_lobby() -> void:
	if _stage == Stage.LEAVING:
		return
	_stage = Stage.LEAVING
	SceneCore.change_scene(ResourceKey.SCENE__LOBBY__LOBBY, null)
