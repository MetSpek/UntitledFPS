extends Spatial


var enemy_spawns_left
var level_finished = false

func _ready():
	check_enemy_spawn_count()

func _process(delta):
	check_enemy_spawn_count()

func check_enemy_spawn_count():
	enemy_spawns_left = self.get_child_count()
	if enemy_spawns_left == 0 and !level_finished:
		level_finished = true
		get_tree().call_group("Teleporter", "level_finished")
