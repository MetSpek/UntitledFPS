extends Node

#WEAPONS
var clip_size_max
var clip_size_current

var max_bullets
var current_bullets
var weapon_damage
var weapon_fire_animation
var weapon_reload_animation

var shotgun = {
	"name" : "Shotgun",
	"damage" : 20,
	"clip_size" : 2,
	"vertical_recoil" : 2,
	"horizontal_recoil" : .01,
	"fire_animation" : "ShotgunFire",
	"reload_animation" : "ShotgunReload",
}

var smg ={
	"name" : "Smg",
	"damage" : 4,
	"clip_size" : 25,
	"vertical_recoil" : 1,
	"horizontal_recoil" : .05,
	"fire_animation" : "SmgFire",
	"reload_animation" : "SmgReload"
}

var assault ={
	"name" : "Assault",
	"damage" : 7,
	"clip_size" : 30,
	"vertical_recoil" : .5,
	"horizontal_recoil" : .01,
	"fire_animation" : "AssaultFire",
	"reload_animation" : "AssaultReload"
}

var pistol ={
	"name" : "Pistol",
	"damage" : 10,
	"clip_size" : 7,
	"vertical_recoil" : .0001,
	"horizontal_recoil" : 0,
	"fire_animation" : "PistolFire",
	"reload_animation" : "PistolReload"
}

var weapons = [assault, smg, shotgun, pistol]

var currently_holding_index = 0
var currently_holding = weapons[currently_holding_index]

#LEVEL
var level = 1

#PLAYER
var xp_required = [100,200,300,400,500,600,700,800,900,1000,1200,1400,1600,1800,2000,2200,2400,2600,2800,3000]


func _ready():
	max_bullets = 9999
	current_bullets = max_bullets
	set_weapon_variables()

func _physics_process(delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	elif Input.is_action_pressed("reload_scene"):
		get_tree().reload_current_scene()

func switch_weapon():
	currently_holding = weapons[currently_holding_index]
	set_weapon_variables()

func set_weapon_variables():
	clip_size_max = currently_holding.clip_size
	clip_size_current = clip_size_max
	weapon_damage = currently_holding.damage
	weapon_fire_animation = currently_holding.fire_animation
	weapon_reload_animation = currently_holding.reload_animation

func enemy_killed(money, xp):
	check_level_up(xp)
	give_money(money)
	
	print(PlayerData.xp)
	print(PlayerData.money)

func give_money(money):
	PlayerData.money += money * level

func check_level_up(xp):
	PlayerData.xp += xp
	
	if PlayerData.xp == xp_required[PlayerData.level]:
		PlayerData.level += 1
		PlayerData.xp = 0
	elif PlayerData.xp > xp_required[PlayerData.level]:
		PlayerData.xp = PlayerData.xp - xp_required[PlayerData.level]
		PlayerData.level += 1
		
		
