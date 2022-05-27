extends Control

onready var current_bullets = $CurrentBullets
onready var total_bullets = $TotalBullets

func fired(bullets):
	set_text(current_bullets, bullets) 
	
func reloaded():
	set_text(total_bullets, GlobalGameHandler.currentBullets)

func set_text(object, text):
	object.text = str(text)
