extends Node

var clip_size_max = 2
var clip_size_current = clip_size_max

var max_bullets = 100
var current_bullets = max_bullets
var weapon_damage = 10


func _physics_process(delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	elif Input.is_action_pressed("reload_scene"):
		get_tree().reload_current_scene()
