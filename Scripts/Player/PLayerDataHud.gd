extends Control

onready var money = $Control/ColorRect/Money
onready var level = $Control/ColorRect/Level

onready var progress = $Control/ColorRect/ProgressBar

func _ready():
	set_data()

func _process(delta):
	set_data()

func set_data():
	money.text = str(PlayerData.money)
	level.text = str(PlayerData.level)
	progress.max_value = GlobalGameHandler.xp_required[PlayerData.level]
	progress.value = PlayerData.xp

