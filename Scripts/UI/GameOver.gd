extends Control


func switch_gameover_visibility():
	visible = !visible

func game_over():
	switch_gameover_visibility()
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_Button_pressed():
	switch_gameover_visibility()
	get_tree().paused = false
	GlobalGameHandler.reset_values()
	Upgrades.reset_upgrades()
	get_tree().change_scene("res://Scenes/Worlds/MainMenu.tscn")
	
