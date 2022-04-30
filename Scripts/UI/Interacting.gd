extends Control

onready var label = $InteractingLabel

func show_text():
	label.show()

func hide_text():
	label.hide()
	

func set_text(interaction):
	label.text = "Press E to: " + str(interaction)
