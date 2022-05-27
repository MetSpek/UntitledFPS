extends Control

onready var hitmark = $Hitmark
onready var timer = $Hitmark/HitmarkTimer
onready var sound = $HitmarkSound

func _ready():
	hitmark.visible = false

func show_hitmark():
	hitmark.visible = true
	sound.play()
	timer.start()


func _on_HitmarkTimer_timeout():
	hitmark.visible = false
