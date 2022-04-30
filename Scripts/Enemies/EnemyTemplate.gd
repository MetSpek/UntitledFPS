extends RigidBody


export var health = 20
export var money_worth = 1
export var xp_worth = 5
export var damage = 10
export var fov_distance = 30
export var move_speed = 10
export var min_time = 3
export var max_time = 5

export var able_to_shoot = true
export var able_to_move = true
export var can_respawn = false
export var can_die = true
export var knockback_force = 50

export var bullet_speed = 100

var is_dead = false
var is_looking_at_player = false
var impact_point = Vector3.ZERO
var player
var player_head
var player_focus
var can_shoot = false

onready var death_timer = $DeathTimer
onready var raycast = $Head/Vision
onready var bullet_cooldown = $BulletCooldown
var bullet_projectile = preload("res://Scenes/Weapons/BulletProjectile.tscn")
onready var bullet_origin = $Head/BulletOrigin
onready var head = $Head
onready var body = $Body
onready var move_timer = $MoveTimer
onready var laser = $Laser/Laser
onready var laser_line = $Laser/Laser/LaserCylinder
onready var enemy_animation = $EnemyAnimation


onready var enemy_sound = $EnemySound
var shoot_sound = preload("res://Resources/Sounds/Guns/Guns/Bullet.ogg")

func _ready():
	player = get_node("/root").find_node("PlayerTemplate", true, false)
	player_head = player.find_node("Head", true, false)
	player_focus = player.find_node("LaserFocus", true, false).get_child(0)
	

func _physics_process(delta):
	if health <= 0:
		if !is_dead:
			dead()
	else:
		raycast.look_at_from_position(global_transform.origin, player_head.global_transform.origin, Vector3.UP)
		check_LOS()
		rotate_to_player()
		move_enemy()

func move_enemy():
	if move_timer.time_left == 0 and able_to_move:
		var dir = Vector3(rand_range(-1,1),rand_range(-0.5,0.5),rand_range(-1,1) * move_speed)
		self.apply_central_impulse(dir)
		if !is_looking_at_player:
			head.look_at(dir, Vector3.UP)
		move_timer.wait_time = rand_range(min_time, max_time)
		move_timer.start()

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
		laser.look_at(player_focus.global_transform.origin, Vector3.UP)
		laser_line.height = raycast.get_collision_point().distance_to(laser.global_transform.origin) * 2
		shoot_at_player()
	else:
		laser_line.height = 0.01


func shoot_at_player():
	if is_looking_at_player and can_shoot and able_to_shoot:
		enemy_animation.play("LaserShoot")
		raycast.get_collider().health -= damage
		get_tree().call_group("HealthBar", "set_health")
		can_shoot = false
		enemy_sound.stream = shoot_sound
		enemy_sound.play()
	else:
		if bullet_cooldown.time_left == 0:
			bullet_cooldown.start()
	
func _on_BulletCooldown_timeout():
	can_shoot = true


func dead():
	if can_die:
		laser_line.height = 0.01
		get_tree().call_group("KillSound", "play_sound")
		is_dead = true
		axis_lock_angular_x = false
		axis_lock_angular_z = false
		gravity_scale = 1
		apply_central_impulse(-impact_point * knockback_force)
		death_timer.start()
		
		GlobalGameHandler.enemy_killed(money_worth, xp_worth)



func _on_DeathTimer_timeout():
	if can_respawn:
		get_parent().spawn()
	else:
		queue_free()


