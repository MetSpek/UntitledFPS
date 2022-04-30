extends Spatial

onready var button = $UpgradePoleButton
export var text = "Upgrade"

func glow():
	get_tree().call_group("InteractingHud", "show_text")
	get_tree().call_group("InteractingHud", "set_text", text)
	button.material.emission_energy = 0.1

func hide():
	get_tree().call_group("InteractingHud", "hide_text")
	get_tree().call_group("InteractingHud", "toggle_text")
	button.material.emission_energy = 0

func interact():
	print("boe")
