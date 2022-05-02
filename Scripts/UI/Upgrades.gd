extends Control

onready var money_label = $Background/MoneyLabel

#Pistol
onready var pistol_damage_level = $VBoxContainer/Pistol/VBoxContainer/PistolDamage/PistolDamageLevel
onready var pistol_damage_price = $VBoxContainer/Pistol/VBoxContainer/PistolDamage/Cost
var pistol_damage_pricelist = [100, 150, 250, 400, 600, 850, 1150, 1500, 1900, 2350]
onready var pistol_ammo_level = $VBoxContainer/Pistol/VBoxContainer/PistolAmmo/PistolAmmoLevel
onready var pistol_ammo_price = $VBoxContainer/Pistol/VBoxContainer/PistolAmmo/Cost
var pistol_ammo_pricelist = [100, 150, 250, 400, 600, 850, 1150, 1500, 1900, 2350]

#Smg
onready var smg_damage_level = $VBoxContainer/Smg/VBoxContainer/SmgDamage/SmgDamageLevel
onready var smg_damage_price = $VBoxContainer/Smg/VBoxContainer/SmgDamage/Cost
var smg_damage_pricelist = [100, 150, 250, 400, 600, 850, 1150, 1500, 1900, 2350]
onready var smg_ammo_level = $VBoxContainer/Smg/VBoxContainer/SmgAmmo/SmgAmmoLevel
onready var smg_ammo_price = $VBoxContainer/Smg/VBoxContainer/SmgAmmo/Cost
var smg_ammo_pricelist = [100, 150, 250, 400, 600, 850, 1150, 1500, 1900, 2350]

#Assault
onready var assault_damage_level = $VBoxContainer/Assault/VBoxContainer/AssaultDamage/AssaultDamageLevel
onready var assault_damage_price = $VBoxContainer/Assault/VBoxContainer/AssaultDamage/Cost
var assault_damage_pricelist = [100, 150, 250, 400, 600, 850, 1150, 1500, 1900, 2350]
onready var assault_ammo_level = $VBoxContainer/Assault/VBoxContainer/AssaultAmmo/AssaultAmmoLevel
onready var assault_ammo_price = $VBoxContainer/Assault/VBoxContainer/AssaultAmmo/Cost
var assault_ammo_pricelist = [100, 150, 250, 400, 600, 850, 1150, 1500, 1900, 2350]

#Sniper
onready var sniper_damage_level = $VBoxContainer/Sniper/VBoxContainer/SniperDamage/SniperDamageLevel
onready var sniper_damage_price = $VBoxContainer/Sniper/VBoxContainer/SniperDamage/Cost
var sniper_damage_pricelist = [100, 150, 250, 400, 600, 850, 1150, 1500, 1900, 2350]
onready var sniper_ammo_level = $VBoxContainer/Sniper/VBoxContainer/SniperAmmo/SniperAmmoLevel
onready var sniper_ammo_price = $VBoxContainer/Sniper/VBoxContainer/SniperAmmo/Cost
var sniper_ammo_pricelist = [100, 150, 250, 400, 600, 850, 1150, 1500, 1900, 2350]

#Player
onready var player_health_level = $VBoxContainer/Player/VBoxContainer/PlayerHealth/PlayerHealthLevel
onready var player_health_price = $VBoxContainer/Player/VBoxContainer/PlayerHealth/Cost
var player_health_pricelist = [100, 150, 250, 400, 600, 850, 1150, 1500, 1900, 2350]
onready var player_speed_level = $VBoxContainer/Player/VBoxContainer/MovementSpeed/MovementSpeedLevel
onready var player_speed_price = $VBoxContainer/Player/VBoxContainer/MovementSpeed/Cost
var player_speed_pricelist = [100, 150, 250, 400, 600, 850, 1150, 1500, 1900, 2350]
onready var player_slide_level = $VBoxContainer/Player/VBoxContainer/SlideSpeed/SlideSpeedLevel
onready var player_slide_price = $VBoxContainer/Player/VBoxContainer/SlideSpeed/Cost
var player_slide_pricelist = [100, 150, 250, 400, 600, 850, 1150, 1500, 1900, 2350]
onready var player_jump_level = $VBoxContainer/Player/VBoxContainer/Jump/JumpLevel
onready var player_jump_price = $VBoxContainer/Player/VBoxContainer/Jump/Cost
var player_jump_pricelist = [100, 150, 250, 400, 600, 850, 1150, 1500, 1900, 2350]

#Other
onready var other_ammo_level = $VBoxContainer/Other/VBoxContainer/StartingAmmo/StartAmmoLevel
onready var other_ammo_price = $VBoxContainer/Other/VBoxContainer/StartingAmmo/Cost
var other_ammo_pricelist = [100, 150, 250, 400, 600, 850, 1150, 1500, 1900, 2350]
onready var other_xp_level = $VBoxContainer/Other/VBoxContainer/XpMultiplier/XpMultiplierLevel
onready var other_xp_price = $VBoxContainer/Other/VBoxContainer/XpMultiplier/Cost
var other_xp_pricelist = [100, 150, 250, 400, 600, 850, 1150, 1500, 1900, 2350]
onready var other_money_level = $VBoxContainer/Other/VBoxContainer/MoneyMultiplier/MoneyMultiplierLevel
onready var other_money_price = $VBoxContainer/Other/VBoxContainer/MoneyMultiplier/Cost
var other_money_pricelist = [100, 150, 250, 400, 600, 850, 1150, 1500, 1900, 2350]

var levels
var prices

func _ready():
	make_dicts()
	update_values()

func _process(delta):
	if visible:
		if Input.is_action_just_pressed("ui_cancel"):
			close()

func show():
	visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	update_money_label()
	get_tree().paused = true

func close():
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false

func update_money_label():
	money_label.text = "$" + str(PlayerData.money)

func make_dicts():
	levels = [
		{
			"label" : pistol_damage_level,
			"value" : PlayerData.pistol_damage_level},
		{
			"label" : pistol_ammo_level,
			"value" : PlayerData.pistol_ammo_level},
		{
			"label" : smg_damage_level,
			"value" : PlayerData.smg_damage_level},
		{
			"label" : smg_ammo_level,
			"value" : PlayerData.smg_ammo_level},
		{
			"label" : assault_damage_level,
			"value" : PlayerData.assault_damage_level},
		{
			"label" : assault_ammo_level,
			"value" : PlayerData.assault_ammo_level},
		{
			"label" : sniper_damage_level,
			"value" : PlayerData.sniper_damage_level},
		{
			"label" : sniper_ammo_level,
			"value" : PlayerData.sniper_ammo_level},
		{
			"label" : player_health_level,
			"value" : PlayerData.health_level},
		{
			"label" : player_speed_level,
			"value" : PlayerData.walk_speed_level},
		{
			"label" : player_slide_level,
			"value" : PlayerData.slide_speed_level},
		{
			"label" : player_jump_level,
			"value" : PlayerData.jump_level},
		{
			"label" : other_ammo_level,
			"value" : PlayerData.starting_ammo_level},
		{
			"label" : other_xp_level,
			"value" : PlayerData.xp_multiplier_level},
		{
			"label" : other_money_level,
			"value" : PlayerData.money_multiplier_level}]
	prices = [
		{"label" : pistol_damage_price,
		 "value" : pistol_damage_pricelist,
		 "level" : PlayerData.pistol_damage_level},
		{"label" : pistol_ammo_price,
		 "value" : pistol_ammo_pricelist,
		 "level" : PlayerData.pistol_ammo_level},
		{"label" : smg_damage_price,
		 "value" : smg_damage_pricelist,
		 "level" : PlayerData.smg_damage_level},
		{"label" : smg_ammo_price,
		 "value" : smg_ammo_pricelist,
		 "level" : PlayerData.smg_ammo_level},
		{"label" : assault_damage_price,
		 "value" : assault_damage_pricelist,
		 "level" : PlayerData.assault_damage_level},
		{"label" : assault_ammo_price,
		 "value" : assault_ammo_pricelist,
		 "level" : PlayerData.assault_ammo_level},
		{"label" : sniper_damage_price,
		 "value" : sniper_damage_pricelist,
		 "level" : PlayerData.sniper_damage_level},
		{"label" : sniper_ammo_price,
		 "value" : sniper_ammo_pricelist,
		 "level" : PlayerData.sniper_ammo_level},
		{"label" : player_health_price,
		 "value" : player_health_pricelist,
		 "level" : PlayerData.health_level},
		{"label" : player_speed_price,
		 "value" : player_speed_pricelist,
		 "level" : PlayerData.walk_speed_level},
		{"label" : player_slide_price,
		 "value" : player_slide_pricelist,
		 "level" : PlayerData.slide_speed_level},
		{"label" : player_jump_price,
		 "value" : player_jump_pricelist,
		 "level" : PlayerData.jump_level},
		{"label" : other_ammo_price,
		 "value" : other_ammo_pricelist,
		 "level" : PlayerData.starting_ammo_level},
		{"label" : other_xp_price,
		 "value" : other_xp_pricelist,
		 "level" : PlayerData.xp_multiplier_level},
		{"label" : other_money_price,
		 "value" : other_money_pricelist,
		 "level" : PlayerData.money_multiplier_level},]

func update_values():
	for x in levels:
		x.label.text = "Level " + str(x.value)
	for y in prices:
		if y.level != 10:
			y.label.text = "$" + str(y.value[y.level])
		else:
			y.label.visible = false
			y.label.get_parent().get_child(2).visible = false
			y.label.get_parent().alignment = 1

func check_money(price):
	if PlayerData.money >= price:
		return true
	else:
		return false

func purchase_upgrade(upgrade, price):
	print(price)
	if check_money(price):
		PlayerData.money -= price
		update_money_label()
		match upgrade:
			"pistol_damage":
				PlayerData.pistol_damage_level += 1
			"pistol_ammo":
				PlayerData.pistol_ammo_level += 1
			"smg_damage":
				PlayerData.smg_damage_level += 1
			"smg_ammo":
				PlayerData.smg_ammo_level += 1
			"assault_damage":
				PlayerData.assault_damage_level += 1
			"assault_ammo":
				PlayerData.assault_ammo_level += 1
			"sniper_damage":
				PlayerData.sniper_damage_level += 1
			"sniper_ammo":
				PlayerData.sniper_ammo_level += 1
			"player_health":
				PlayerData.health_level += 1
			"player_speed":
				PlayerData.walk_speed_level += 1
			"player_slide":
				PlayerData.slide_speed_level += 1
			"player_jump":
				PlayerData.jump_level += 1
			"other_ammo":
				PlayerData.starting_ammo_level += 1
			"other_xp":
				PlayerData.xp_multiplier_level += 1
			"other_money":
				PlayerData.money_multiplier_level += 1
		GlobalGameHandler.set_weapon_values()
		GlobalGameHandler.set_player_values()
		make_dicts()
		update_values()

func _on_Exitbutton_pressed():
	close()
	print("stinky")

func _on_PistolDamageButton_pressed():
	purchase_upgrade("pistol_damage", prices[0].value[PlayerData.pistol_damage_level])

func _on_PistolAmmoButton_pressed():
	purchase_upgrade("pistol_ammo", prices[1].value[PlayerData.pistol_ammo_level])

func _on_SmgDamageButton_pressed():
	purchase_upgrade("smg_damage", prices[2].value[PlayerData.smg_damage_level])

func _on_SmgAmmoButton_pressed():
	purchase_upgrade("smg_ammo", prices[3].value[PlayerData.smg_ammo_level])

func _on_AssaultDamageButton_pressed():
	purchase_upgrade("assault_damage", prices[4].value[PlayerData.assault_damage_level])

func _on_AssaultAmmoButton_pressed():
	purchase_upgrade("assault_ammo", prices[5].value[PlayerData.assault_ammo_level])

func _on_SniperDamageButton_pressed():
	purchase_upgrade("sniper_damage", prices[6].value[PlayerData.sniper_damage_level])

func _on_SniperAmmoButton_pressed():
	purchase_upgrade("sniper_ammo", prices[7].value[PlayerData.sniper_ammo_level])

func _on_PlayerHealthButton_pressed():
	purchase_upgrade("player_health", prices[8].value[PlayerData.health_level])
	print(prices[8].value)

func _on_MovementSpeedButton_pressed():
	purchase_upgrade("player_speed", prices[9].value[PlayerData.walk_speed_level])
	print(prices[9].value)

func _on_SlideSpeedButton_pressed():
	purchase_upgrade("player_slide", prices[9].value[PlayerData.slide_speed_level])
	print(prices[10].value)

func _on_JumpButton_pressed():
	purchase_upgrade("player_jump", prices[10].value[PlayerData.jump_level])
	

func _on_StartAmmoButton_pressed():
	purchase_upgrade("other_ammo", prices[11].value[PlayerData.starting_ammo_level])

func _on_XpMultiplierButton_pressed():
	purchase_upgrade("other_xp", prices[12].value[PlayerData.xp_multiplier_level])

func _on_MoneyMultiplierButton_pressed():
	purchase_upgrade("other_money", prices[13].value[PlayerData.money_multiplier_level])
