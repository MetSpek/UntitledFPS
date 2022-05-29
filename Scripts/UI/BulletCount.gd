extends Control

onready var current_bullets = $CurrentBullets
onready var total_bullets = $TotalBullets

var pistolEquiped = false

func fired(bullets):
	set_text(current_bullets, bullets) 
	
func reloaded():
	if  not pistolEquiped:
		set_text(total_bullets, GlobalGameHandler.currentBullets)

func set_text(object, text):
	object.text = str(text)

func start_pistol():
	pistolEquiped = true
	total_bullets.text = "∞"

func pistol_unequip():
	pistolEquiped = false
