extends RigidBody

var ammo_amount


func _on_PickupRange_body_entered(body):
	if body.name == "PlayerTemplate":
		GlobalGameHandler.current_bullets += int(ammo_amount * GlobalGameHandler.difficulty)
		get_tree().call_group("HUD", "reloaded")
		queue_free()
