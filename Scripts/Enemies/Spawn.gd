extends Spatial

export var enemy_count : int
export var offset_x : int
export var offset_y : int
export var offset_z : int
var enemy = preload("res://Scenes/Enemies/EnemyDrone.tscn")


func _ready():
	for x in enemy_count:
		GlobalGameHandler.enemies_left += 1
		spawn()

func _process(delta):
	if self.get_child_count() == 0:
		queue_free()

func spawn():
	var enemy_instance = enemy.instance()
	enemy_instance.health = enemy_instance.health * GlobalGameHandler.difficulty
	enemy_instance.transform.origin = Vector3(rand_range(-offset_x,offset_x),rand_range(0,offset_y),rand_range(-offset_z, offset_z))
	enemy_instance.rotation_degrees.y = rand_range(0,360)
	self.add_child(enemy_instance)
	
