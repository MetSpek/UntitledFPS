extends Control

onready var label = $Label

func _process(delta):
	label.text = "Enemies left: " + str(GlobalGameHandler.enemies_left)
