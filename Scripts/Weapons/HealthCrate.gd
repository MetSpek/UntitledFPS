extends RigidBody



var health_amount

var player

func _ready():
	if get_node("/root").find_node("Player", true, false):
		player = get_node("/root").find_node("Player", true, false)
	
func _on_PickupRange_body_entered(body):
	if body.name == "Player":
		if GlobalGameHandler.player_health < GlobalGameHandler.player_max_health:
			GlobalGameHandler.player_health += health_amount
			if GlobalGameHandler.player_health > GlobalGameHandler.player_max_health:
				GlobalGameHandler.player_health = GlobalGameHandler.player_max_health
			get_tree().call_group("HealthBar", "set_health")
			queue_free()
