class_name TitleScene
extends SceneBase
## Title scene of the boot: the game name and the tagline over the sky while the game signs in.

@export var title_label: Label
@export var tagline_label: Label
@export var sky: TextureRect
@export var blocks: Array[NinePatchRect] = []


func on_preload(preload_request: PreloadRequest, _prefill_items: Array[PrefillItem]) -> void:
	preload_request.add_item(ResourceKey.BACKGROUND__SKY, ResourceCore.BaseKind.TEXTURE_2D)
	preload_request.add_item(ResourceKey.NINE_SLICE__BLOCK, ResourceCore.BaseKind.TEXTURE_2D)


func _ready() -> void:
	LocalizationCore.bind_text(title_label, ReservedString.app_name())
	LocalizationCore.bind_text(tagline_label, ReservedString.title_tagline())


func on_start() -> void:
	if ResourceCore.is_loaded(ResourceKey.BACKGROUND__SKY, ResourceCore.BaseKind.TEXTURE_2D):
		sky.texture = ResourceCore.get_loaded(ResourceKey.BACKGROUND__SKY, ResourceCore.BaseKind.TEXTURE_2D, scope) as Texture2D
	for i: int in blocks.size():
		blocks[i].self_modulate = CommonBlockColor.of_level(i * CommonConstants.BLOCKS_PER_COLOR)
