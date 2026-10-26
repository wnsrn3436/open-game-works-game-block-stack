class_name ContentBoot
extends ContentEntry
## Content entry of the game. The game registers no core hook, and the first scene after login is the lobby of game
## settings `firstScene`.


func content_init() -> bool:
	return true


func content_release() -> void:
	pass


func select_first_scene() -> String:
	return BootstrapCore.get_first_scene()
