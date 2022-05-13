extends Spatial

enum {
	NORMAL,
	GLIDING
}

var player
var velocity
var standard_velocity
export var move_x : float
export var move_y : float
export var move_z : float
export var slowdown : float

onready var path = $Path/PathFollow
var moved_child = false

func _ready():
	standard_velocity = Vector3(move_x, move_y, move_z)

func _physics_process(delta):
	if player != null:
		velocity = Vector3(move_x, move_y, move_z)
		player.move_and_slide(velocity)
		if player.is_player_on_floor:
			if move_x > 0:
				move_x -= slowdown
			elif move_x < 0:
				move_x += slowdown
				
			if move_y > 0:
				move_y -= slowdown
			elif move_y < 0:
				move_y += slowdown
			
			if move_z > 0:
				move_z -= slowdown
			elif move_z < 0:
				move_z += slowdown
		
		if move_x == 0 and move_y == 0 and move_z == 0:
			player.player_state = NORMAL
			player = null
			reset_values()

func reset_values():
	move_x = standard_velocity.x
	move_y = standard_velocity.y
	move_z = standard_velocity.z
	

func _on_Area_body_entered(body):
	if body.name == "PlayerTemplate" and !moved_child:
		player = body
		player.movement = Vector3(0,0,0)
		print(player.movement)
		player.player_state = GLIDING
