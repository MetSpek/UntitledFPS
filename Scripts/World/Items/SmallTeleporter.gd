extends Spatial


export var teleport_group : int
export var teleporter : int

func call_teleport_object(body):
	get_tree().call_group("SmallTeleporter", "teleport_object", body, teleport_group, teleporter)

func teleport_object(body, group, number):
	if group == teleport_group and not number == teleporter:
		body.global_transform.origin = global_transform.origin 
		body.global_transform.origin.y += 5

func _on_Area_body_entered(body):
	call_teleport_object(body)
