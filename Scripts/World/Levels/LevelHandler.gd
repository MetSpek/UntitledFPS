extends Node

func _ready():
	GlobalGameHandler.find_player()
	GlobalGameHandler.add_all_weapons()

