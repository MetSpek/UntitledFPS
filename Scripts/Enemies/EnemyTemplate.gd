extends RigidBody


export var health = 20
export var fov_distance = 30

export var knockback_force = 50
export var bullet_speed = 100

var is_dead = false
var is_looking_at_player = false
var impact_point = Vector3.ZERO
var player
var player_head
var can_shoot = false

onready var death_timer = $DeathTimer
onready var raycast = $Head/Vision
onready var bullet_cooldown = $BulletCooldown
var bullet_projectile = preload("res://Scenes/Weapons/BulletProjectile.tscn")
onready var bullet_origin = $Head/BulletOrigin
onready var head = $Head
onready var body = $Body


onready var enemy_sound = $EnemySound
var shoot_sound = preload("res://Resources/Sounds/Guns/Guns/Bullet.ogg")

func _ready():
	player = get_node("/root").find_node("PlayerTemplate", true, false)
	player_head = player.find_node("Head", true, false)


func _physics_process(delta):
	if health <= 0:
		if !is_dead:
			dead()
	else:
		raycast.look_at_from_position(global_transform.origin, player_head.global_transform.origin, Vector3.UP)
		check_LOS()
		rotate_to_player()


func check_LOS():
	if raycast.get_collider() == player:
		if raycast.rotation_degrees.y < fov_distance and raycast.rotation_degrees.y > -fov_distance:
			is_looking_at_player = true
		else:
			is_looking_at_player = false
	else:
		is_looking_at_player = false
		

func rotate_to_player():
	if is_looking_at_player:
		head.look_at(player_head.global_transform.origin, Vector3.UP)
		body.look_at(player_head.global_transform.origin, Vector3.UP)
		body.rotation.x = clamp(body.rotation.x, 0, 0)
		shoot_at_player()


func shoot_at_player():
	if is_looking_at_player and can_shoot:
		var bullet = bullet_projectile.instance()
		var dir = global_transform.origin.direction_to(player_head.global_transform.origin - Vector3(0,3,0))
		get_tree().get_root().get_node("WorldTemplate").add_child(bullet)
		bullet.global_transform.origin = bullet_origin.global_transform.origin
		bullet.apply_central_impulse(dir * bullet_speed)
		bullet.rotation = rotation
		bullet.rotation = rotation
		can_shoot = false
		enemy_sound.stream = shoot_sound
		enemy_sound.play()
	else:
		if bullet_cooldown.time_left == 0:
			bullet_cooldown.start()
	
func _on_BulletCooldown_timeout():
	can_shoot = true


func dead():
	is_dead = true
	axis_lock_angular_x = false
	axis_lock_angular_z = false
	apply_central_impulse(-impact_point * knockback_force)
	death_timer.start()



func _on_DeathTimer_timeout():
	queue_free()


