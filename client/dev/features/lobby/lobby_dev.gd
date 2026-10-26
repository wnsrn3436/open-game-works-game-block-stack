class_name LobbyDev
extends RefCounted
## DEV registration of the lobby feature: the screen commands.


static func register() -> void:
	QACore.register_command("lobby.open_lobby", "Opens the lobby scene with its root panel on top.", PackedStringArray(),
		func(_args: PackedStringArray) -> RunCommandResult: return await LobbyDev.open_lobby())
	QACore.register_command("lobby.open_option", "Opens the option panel over the lobby.", PackedStringArray(),
		func(_args: PackedStringArray) -> RunCommandResult: return await LobbyDev.open_option())


static func open_lobby() -> RunCommandResult:
	UICore.close_all_popups()
	if SceneCore.current_scene_key() != ResourceKey.SCENE__LOBBY__LOBBY:
		if not await SceneCore.change_scene(ResourceKey.SCENE__LOBBY__LOBBY, null):
			return _result(false, "\"the lobby did not open\"")
	for i: int in LobbyConstants.DEV_WAIT_FRAMES:
		if not UICore.is_panel_transitioning():
			break
		await (Engine.get_main_loop() as SceneTree).process_frame
	return _result(await UICore.close_panels_to(ResourceKey.PREFAB__LOBBY__LOBBY_PANEL), "\"the lobby did not open\"")


static func open_option() -> RunCommandResult:
	var lobby: RunCommandResult = await open_lobby()
	if not lobby.ok:
		return lobby
	return _result(await UICore.open_panel(ResourceKey.PREFAB__LOBBY__OPTION_PANEL, null, false), "\"the option panel did not open\"")


static func _result(ok: bool, failure: String) -> RunCommandResult:
	var out: RunCommandResult = RunCommandResult.new()
	out.ok = ok
	out.result = "" if ok else failure
	return out
