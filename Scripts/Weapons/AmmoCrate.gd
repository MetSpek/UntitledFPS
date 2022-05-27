extends RigidBody

var ammo_amount


func _on_PickupRange_body_entered(body):
	if body.name == "Player":
		GlobalGameHandler.currentBullets += int(ammo_amount * GlobalGameHandler.difficulty)
		get_tree().call_group("HUD", "reloaded")
		queue_free()
