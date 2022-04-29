extends StaticBody

onready var platform = $Platform
var can_teleport = false

func level_finished():
	can_teleport = true
	var material = platform.get_surface_material(0)
	material.albedo_color = Color.green

func _on_Area_body_entered(body):
	if can_teleport:
		get_tree().reload_current_scene()
