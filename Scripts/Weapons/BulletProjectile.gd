extends RigidBody

onready var life_time = $LifeTime
onready var collision = $CollisionShape

func _ready():
	life_time.start()

func _on_LifeTime_timeout():
	queue_free()


func _on_Area_body_entered(body):
	queue_free()
