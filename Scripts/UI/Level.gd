extends Control


onready var level_label = $ColorRect/LevelLabel

func _ready():
	update_label()

func update_label():
	level_label.text = "Level: " + str(GlobalGameHandler.level)
