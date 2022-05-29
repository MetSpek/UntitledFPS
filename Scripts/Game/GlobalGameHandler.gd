extends Node

#WEAPONS
var clip_size_max
var clip_size_current

var max_bullets
var currentBullets
var weapon_damage
var weapon_fire_animation
var weapon_reload_animation

const STARTPISTOL = preload("res://Scenes/Weapons/Pistol.tscn")
var startPistolDamageLevel = 0
var startPistolAmmoLevel = 0
var currentStartPistolClip


const SUBMACHINEGUN = preload("res://Scenes/Weapons/Smg.tscn")
var smgDamageLevel = 0
var smgAmmoLevel = 0
var currentSmgClip

var sniper = {
	"name" : "Shotgun",
	"damage" : 20,
	"clip_size" : 2,
	"vertical_recoil" : 2,
	"horizontal_recoil" : .01,
	"fire_animation" : "ShotgunFire",
	"reload_animation" : "ShotgunReload",
	"fire_sound" : null
}

var smg ={
	"name" : "Smg",
	"damage" : 4,
	"clip_size" : 25,
	"vertical_recoil" : .5,
	"horizontal_recoil" : .05,
	"fire_animation" : "SmgFire",
	"reload_animation" : "SmgReload",
	"fire_sound" : preload("res://Resources/Sounds/Guns/Guns/SmgFire.wav")
}

var assault ={
	"name" : "Assault",
	"damage" : 7,
	"clip_size" : 30,
	"vertical_recoil" : .5,
	"horizontal_recoil" : .01,
	"fire_animation" : "AssaultFire",
	"reload_animation" : "AssaultReload",
	"fire_sound" : preload("res://Resources/Sounds/Guns/Guns/AssaultFire.wav")
}

var pistol ={
	"name" : "Pistol",
	"damage" : 10,
	"clip_size" : 7,
	"vertical_recoil" : .0001,
	"horizontal_recoil" : 0,
	"fire_animation" : "PistolFire",
	"reload_animation" : "PistolReload",
	"fire_sound" : null
}

var weapons = []

var currently_holding_index = 0
var currently_holding


var current_pistol_clip

var current_assault_clip
var current_sniper_clip
var to_reload_ammo

#LEVEL
var level = 0
var scaling_a = 1
var scaling_b = 1.1
var start_height = -.5
var difficulty = 0
var enemies_left = 0


onready var levels = ["res://Scenes/Worlds/Levels/FloatingIsland/LevelFloatingislands.tscn"]


#PLAYER
var xp_required = [100,200,300,400,500,600,700,800,900,1000,1200,1400,1600,1800,2000,2200,2400,2600,2800,3000]
var money_awarded = [10,20,30,40,50,60,70,80,90,100,120,140,160,180,200,220,240,260,280,300]

var player_max_health
var player_health
var player_walk_speed
var player_slide_speed
var player_jump

var player_starting_ammo
var player_xp_multiplier
var player_money_multiplier




var smg_damage_values = [2,3,4,5,6,7,8,9,10,11,12]
var smg_ammo_values = [20,25,30,35,40,45,50,55,60,65,70]
var assault_damage_values = [5,7,9,11,13,15,17,19,21,23,25]
var assault_ammo_values = [30,35,40,45,50,55,60,65,70,75,80]
var sniper_damage_values = [15,20,25,30,35,40,45,50,55,60,65]
var sniper_ammo_values = [1,2,3,4,5,6,7,8,9,10,11]
var pistol_damage_values = [7,10,13,16,19,22,25,28,31,34,37]
var pistol_ammo_values = [7,10,13,16,19,22,25,28,31,34,37]

var health_values = [100,150,200,250,300,350,400,450,500,550,600]
var walk_speed_values = [10.0,11.0,12.0,13.0,14.0,15.0,16.0,17.0,18.0,19.0,20.0]
var slide_speed_values = [20.0,22.0,24.0,26.0,28.0,20.0,22.0,24.0,26.0,28.0,20.0]
var jump_values = [8,9,10,11,12,13,14,15,16,17,18]

var starting_ammo_values = [250,500,750,1000,1250,1500,1750,2000,2250,2500,2750]
var xp_multiplier_values = [1,1.2,1.4,1.6,1.8,2,2.2,2.4,2.6,2.8,3]
var money_multiplier_values = [1,1.2,1.4,1.6,1.8,2,2.2,2.4,2.6,2.8,3]

func _ready():

	current_pistol_clip = pistol_ammo_values[PlayerData.pistol_ammo_level]
	current_assault_clip = assault_ammo_values[PlayerData.assault_ammo_level]
	current_sniper_clip = sniper_ammo_values[PlayerData.sniper_ammo_level]
#	set_weapon_variables()
	set_difficulty()
#	set_weapon_values()
	set_player_values()
	currentBullets = player_starting_ammo
	

func _physics_process(delta):
	if Input.is_action_just_pressed("close_game"):
		get_tree().quit()
	elif Input.is_action_pressed("reload_scene"):
		get_tree().reload_current_scene()
		select_next_level()
	elif Input.is_action_just_pressed("finish_level"):
		finish_level()

func start_game():
	add_weapon(STARTPISTOL)
	GlobalGameHandler.select_next_level()

func reset_values():
	set_player_values()
	weapons = []
	difficulty = 0

func set_difficulty():
	difficulty = scaling_a*(pow(scaling_b, level) + start_height)


func set_weapon_values():
	sniper.damage = sniper_damage_values[PlayerData.sniper_damage_level]
	sniper.clip_size = sniper_ammo_values[PlayerData.sniper_ammo_level]
	smg.damage = smg_damage_values[PlayerData.smg_damage_level]
	smg.clip_size = smg_ammo_values[PlayerData.smg_ammo_level]
	assault.damage = assault_damage_values[PlayerData.assault_damage_level]
	assault.clip_size = assault_ammo_values[PlayerData.assault_ammo_level]
	pistol.damage = assault_damage_values[PlayerData.pistol_damage_level]
	pistol.clip_size = pistol_ammo_values[PlayerData.pistol_ammo_level]
#	set_weapon_variables()

func set_player_values():
	player_max_health = health_values[PlayerData.health_level]
	player_health = player_max_health
	player_walk_speed = walk_speed_values[PlayerData.walk_speed_level]
	player_slide_speed = slide_speed_values[PlayerData.slide_speed_level]
	player_jump = jump_values[PlayerData.jump_level]
	player_starting_ammo = starting_ammo_values[PlayerData.starting_ammo_level]
	player_xp_multiplier = xp_multiplier_values[PlayerData.xp_multiplier_level]
	player_money_multiplier = money_multiplier_values[PlayerData.money_multiplier_level]


func add_weapon(weapon):
	weapons.append(weapon)

func remove_weapon(weapon):
	weapons.erase(weapon)

func enemy_killed(money, xp):
	check_level_up(xp)
	give_money(money)

func give_money(money):
	PlayerData.money += (money * level) * player_money_multiplier

func check_level_up(xp):
	var xp_index = 0
	PlayerData.xp += (xp * level) * player_xp_multiplier
	if PlayerData.level > xp_required.size():
		xp_index = xp_required.size() - 1
	else:
		xp_index = PlayerData.level
		
	if PlayerData.xp == xp_required[xp_index]:
		level_up_player()
		PlayerData.xp = 0
	elif PlayerData.xp > xp_required[xp_index]:
		PlayerData.xp = PlayerData.xp - xp_required[PlayerData.level]
		level_up_player()

func level_up_player():
	PlayerData.level += 1
	if PlayerData.level > money_awarded.size():
		PlayerData.money += money_awarded[money_awarded.size() - 1]
	else:
		PlayerData.money += money_awarded[PlayerData.level - 1]

func finish_level():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().call_group("HUD", "switch_upgrades_visibility")

func select_next_level():
	get_tree().paused = false
	var new_scene = levels[rand_range(0, levels.size() - 1)]
	get_tree().change_scene(new_scene)
	level += 1
	set_difficulty()
	get_tree().call_group("LevelHud", "update_label")
	
	
