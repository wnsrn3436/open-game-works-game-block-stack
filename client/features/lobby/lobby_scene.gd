class_name LobbyScene
extends SceneBase
## Lobby scene after sign-in. Its root panel holds the record, the demo tower and the play and option buttons. It plays
## the BGM and receives the pending UserState changes when it starts.

@export var sky: TextureRect


func on_preload(preload_request: PreloadRequest, _prefill_items: Array[PrefillItem]) -> void:
	for key: String in [ResourceKey.BACKGROUND__SKY, ResourceKey.NINE_SLICE__BLOCK, ResourceKey.ICON__BEST]:
		preload_request.add_item(key, ResourceCore.BaseKind.TEXTURE_2D)
	preload_request.add_item(ResourceKey.BGM__MAIN, ResourceCore.BaseKind.AUDIO_STREAM)
	var tween_kind: int = TweenCore.get_preset_kind()
	for key: String in [ResourceKey.TWEEN__LOBBY__DEMO_SLIDE, ResourceKey.TWEEN__LOBBY__PLAY_PULSE,
			ResourceKey.TWEEN__COMMON__PANEL_IN, ResourceKey.TWEEN__COMMON__PANEL_OUT]:
		preload_request.add_item(key, tween_kind)


func on_start() -> void:
	if ResourceCore.is_loaded(ResourceKey.BACKGROUND__SKY, ResourceCore.BaseKind.TEXTURE_2D):
		sky.texture = ResourceCore.get_loaded(ResourceKey.BACKGROUND__SKY, ResourceCore.BaseKind.TEXTURE_2D, scope) as Texture2D
	SoundCore.play_bgm(ResourceKey.BGM__MAIN, scope)
	NetworkCore.resync()
