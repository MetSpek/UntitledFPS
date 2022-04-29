extends Control

onready var current_bullets = $CurrentBullets
onready var total_bullets = $TotalBullets

func _ready():
	fired()
	reloaded()

func fired():
	set_text(current_bullets, GlobalGameHandler.clip_size_current) 
	
func reloaded():
	set_text(total_bullets, GlobalGameHandler.current_bullets)

func set_text(object, text):
	object.text = str(text)
