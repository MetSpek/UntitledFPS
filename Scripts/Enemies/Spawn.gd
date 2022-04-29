extends Spatial

export var enemy_count : int
var enemy = preload("res://Scenes/Enemies/EnemyTemplate.tscn")


func _ready():
	for x in enemy_count:
		spawn()

func _process(delta):
	if self.get_child_count() == 0:
		queue_free()

func spawn():
	var enemy_instance = enemy.instance()
	enemy_instance.health = enemy_instance.health * GlobalGameHandler.difficulty
	self.add_child(enemy_instance)
	
