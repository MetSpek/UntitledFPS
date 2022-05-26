extends RigidBody

onready var life_time = $LifeTime
onready var collision = $CollisionShape

var damage

func _ready():
	life_time.start()

func _on_LifeTime_timeout():
	queue_free()


func _on_Area_body_entered(body):
	if body.name == "Player":
		GlobalGameHandler.player_health -= damage
		get_tree().call_group("HealthBar", "set_health")
	queue_free()
