extends RigidBody



var health_amount

var player

func _ready():
	if get_node("/root").find_node("PlayerTemplate", true, false):
		player = get_node("/root").find_node("PlayerTemplate", true, false)
	
func _on_PickupRange_body_entered(body):
	if body.name == "PlayerTemplate":
		if player.health < GlobalGameHandler.player_health:
			player.health += health_amount
			if player.health > GlobalGameHandler.player_health:
				player.health = GlobalGameHandler.player_health
			get_tree().call_group("HealthBar", "set_health")
			queue_free()
