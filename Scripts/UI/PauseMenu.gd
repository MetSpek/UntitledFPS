extends Control

var isGamePaused = false

func _ready():
	switch_visibilty()

func open_menu():
	switch_visibilty()

func switch_visibilty():
	visible = !visible

func resume():
	isGamePaused = false
	get_tree().paused = false

func _input(event):
	if event.is_action_pressed("pause_game"):
		if isGamePaused == false:
			isGamePaused = true
			get_tree().paused = true
			switch_visibilty()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			_on_ResumeButton_pressed()

func _on_ResumeButton_pressed():
	resume()
	switch_visibilty()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_MainMenuButton_pressed():
	resume()
	get_tree().change_scene("res://Scenes/Worlds/MainMenu.tscn")


func _on_ExitGameButton_pressed():
	get_tree().quit()
