extends DevRegistrationList


func register_all() -> void:
	LobbyDev.register()
	PlayDev.register()
	TitleDev.register()
