extends Control


onready var level_label = $ColorRect/LevelLabel
onready var name_label = $ColorRect/NameLabel
onready var animation = $AnimationPlayer

func _ready():
	update_label()

func update_label():
	animation.play("Popup")
	level_label.text = "Level: " + str(GlobalGameHandler.level)
	name_label.text = get_tree().get_current_scene().get_name()
