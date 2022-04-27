extends Node

var clip_size_max
var clip_size_current

var max_bullets
var current_bullets
var weapon_damage
var weapon_fire_animation
var weapon_reload_animation

var shotgun = {
	"name" : "Shotgun",
	"damage" : 10,
	"clip_size" : 2,
	"vertical_recoil" : 2,
	"horizontal_recoil" : .01,
	"fire_animation" : "ShotgunFire",
	"reload_animation" : "ShotgunReload",
}

var smg ={
	"name" : "Smg",
	"damage" : 2,
	"clip_size" : 25,
	"vertical_recoil" : 1,
	"horizontal_recoil" : .05,
	"fire_animation" : "SmgFire",
	"reload_animation" : "SmgReload"
}

var assault ={
	"name" : "Assault",
	"damage" : 4,
	"clip_size" : 30,
	"vertical_recoil" : .5,
	"horizontal_recoil" : .01,
	"fire_animation" : "AssaultFire",
	"reload_animation" : "AssaultReload"
}

var pistol ={
	"name" : "Pistol",
	"damage" : 7,
	"clip_size" : 7,
	"vertical_recoil" : .0001,
	"horizontal_recoil" : 0,
	"fire_animation" : "PistolFire",
	"reload_animation" : "PistolReload"
}

var weapons = [assault, smg, shotgun, pistol]

var currently_holding_index = 0
var currently_holding = weapons[currently_holding_index]


func _ready():
	max_bullets = 9999
	set_weapon_variables()

func _physics_process(delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	elif Input.is_action_pressed("reload_scene"):
		get_tree().reload_current_scene()

func switch_weapon():
	currently_holding = weapons[currently_holding_index]
	print(currently_holding.name)
	print(currently_holding.fire_animation)
	set_weapon_variables()

func set_weapon_variables():
	clip_size_max = currently_holding.clip_size
	clip_size_current = clip_size_max
	current_bullets = max_bullets
	weapon_damage = currently_holding.damage
	weapon_fire_animation = currently_holding.fire_animation
	weapon_reload_animation = currently_holding.reload_animation
