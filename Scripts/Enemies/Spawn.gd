extends Spatial

var enemy = preload("res://Scenes/Enemies/EnemyTemplate.tscn")

func destroy():
	if self.get_child_count() > 0:
		
		self.get_child(0).queue_free()

func respawn():
	var enemy_instance = enemy.instance()
	enemy_instance.able_to_shoot = self.get_child(0).able_to_shoot
	enemy_instance.can_respawn = self.get_child(0).can_respawn
	self.add_child(enemy_instance)
	
func spawn():
	respawn()
	destroy()
