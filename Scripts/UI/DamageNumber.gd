extends Node

var text = preload("res://Scenes/UI/DamageNumbers.tscn")

func damage_number(damage, location, object):
	var damage_display = text.instance()
	get_tree().get_root().add_child(damage_display)
	damage_display.get_child(0).get_child(0).text = str(damage)
	damage_display.transform.origin = location
	damage_display.transform.origin.y += 1
	damage_display.get_child(0).set_label_size()
