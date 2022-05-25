extends Control

onready var label = $InteractingLabel

func show_text():
	label.visible = true

func hide_text():
	label.visible = false
	

func set_text(interaction):
	label.text = "Press E to: " + str(interaction)
