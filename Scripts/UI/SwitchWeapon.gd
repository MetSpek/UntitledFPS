extends Control

onready var weaponGet = $ColorRect2/VBoxContainer/WeaponToDecide

onready var weapon1 = $ColorRect2/VBoxContainer/HBoxContainer/VBoxContainer/Weapon1
onready var weapon2 = $ColorRect2/VBoxContainer/HBoxContainer/VBoxContainer2/Weapon2

var weaponSelect

func _ready():
	switch_visibilty()

func switch_visibilty():
	visible = !visible

func switch_weapon(weapon):
	weaponSelect = weapon
	switch_visibilty()
	set_text(weaponGet, weapon.title)
	set_text(weapon1, GlobalGameHandler.weapons[1].instance().NAME)
	set_text(weapon2, GlobalGameHandler.weapons[2].instance().NAME)

func set_text(label, text):
	label.text = str(text)

func close():
	get_tree().call_group("HUD", "stop_selecting_weapon")
	switch_visibilty()

func _on_KeepWeapons_pressed():
	close()


func _on_SwitchWeapon1_pressed():
	GlobalGameHandler.remove_weapon(GlobalGameHandler.weapons[1])
	close()


func _on_SwitchWeapon2_pressed():
	GlobalGameHandler.remove_weapon(GlobalGameHandler.weapons[2])
	close()
