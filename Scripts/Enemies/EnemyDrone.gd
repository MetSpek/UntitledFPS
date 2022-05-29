extends KinematicBody



enum{
	IDLE,
	ANGER,
	RAGE,
	LOS,
	DEAD
}

var current_state
export var health = 20
export var money_worth = 1
export var xp_worth = 5
export var damage = 10
export var ammo_return_min = 50
export var ammo_return_max = 75
export var fire_speed = 0.2
export var projectile_speed = 40
export var explosion_damage = 40
export var move_speed = 1
export var rage_acceleration = 0.05
var rage_threshold
export var max_distance_to_player = 50
export var max_notify_distance = 50
export var ammo_drop_chance = 50
export var health_drop_chance = 20

var rage_speed = 10
var is_dead = false
var is_aggrevated = false
var can_change_direction = true
var can_shoot = true

var impact_point = Vector3.ZERO
var move_direction = Vector3.ZERO

#onready var animations = $AnimationPlayer
onready var head = $Head
onready var death_timer = $DeathTimer
onready var move_timer = $MoveTimer
onready var shoot_timer = $ShootTimer
onready var detection = $DetectionRange/CollisionShape
onready var los = $Los
onready var fire_hole = $Head/FireHole

var player
var player_head
var bullet = preload("res://Scenes/Weapons/BulletProjectile.tscn")
var ammo_crate = preload("res://Scenes/Weapons/AmmoCrate.tscn")
var health_crate = preload("res://Scenes/Weapons/HealthCrate.tscn")

func _ready():
	current_state = IDLE
	rage_threshold = health / 3
	if get_node("/root").find_node("Player", true, false):
		player = get_node("/root").find_node("Player", true, false)
		player_head = player.find_node("YawAxis", true, false)

func _process(delta):
	if health <= 0:
		current_state = DEAD
	elif health > 0 and health <= rage_threshold:
		current_state = RAGE
	match current_state:
		IDLE:
			idle_state()
		ANGER:
			anger_state()
		RAGE:
			rage_state()
		LOS:
			los_state()
		DEAD:
			dead_state()
	
func idle_state():
	pass

func anger_state():
	look_at_player()
	if check_los() and can_shoot:
		shoot()
	if can_change_direction:
		can_change_direction = false
		move_direction = Vector3(rand_range(-5,5),rand_range(-.1,.1),rand_range(-5,5))
		move_timer.start()
	if global_transform.origin.distance_to(player.global_transform.origin) < max_distance_to_player:
		move_and_slide(move_direction * move_speed)
		if shoot_timer.time_left <= 0:
			can_shoot = true
	else:
		can_shoot = false
		var velocity = global_transform.origin.direction_to(player.global_transform.origin)
		move_and_slide(velocity * 50, Vector3.UP)

func rage_state():
	look_at_player()
	var velocity = global_transform.origin.direction_to(player.global_transform.origin)
	move_and_slide(velocity * rage_speed, Vector3.UP)
	rage_speed += rage_acceleration

func los_state():
	if check_los():
		current_state = ANGER

func dead_state():
	if !is_dead:
		is_dead = true
		get_tree().call_group("KillSound", "play_sound")
		GlobalGameHandler.enemies_left -= 1
		GlobalGameHandler.enemy_killed(money_worth, xp_worth)
		death_timer.start()

func shoot():
	can_shoot = false
	shoot_timer.wait_time = fire_speed
	shoot_timer.start()
	var velocity = global_transform.origin.direction_to(player.global_transform.origin + player.velocity * (global_transform.origin.distance_to(player.global_transform.origin) / 40))
	var bullet_instance = bullet.instance()
	bullet_instance.global_transform.origin = fire_hole.global_transform.origin
	bullet_instance.damage = damage
	bullet_instance.apply_central_impulse(velocity * projectile_speed)
	get_tree().get_root().add_child(bullet_instance)

func check_los():
	los.look_at_from_position(global_transform.origin, player_head.global_transform.origin, Vector3.UP)
	if los.is_colliding():
		if los.get_collider():
			if los.get_collider().name == "Player":
				return true

func look_at_player():
	if player:
		head.look_at_from_position(global_transform.origin, player_head.global_transform.origin, Vector3.UP)

func aggrevate():
	if !current_state == ANGER and !current_state == RAGE:
		current_state = ANGER
		get_tree().call_group("Enemy", "notify", global_transform.origin)

func notify(origin):
	if !current_state == ANGER and !current_state == RAGE:
		if global_transform.origin.distance_to(origin) < max_notify_distance:
			current_state = ANGER

func _on_DetectionRange_body_entered(body):
	current_state = LOS

func _on_DeathTimer_timeout():
	var ammo_number = rand_range(0,100)
	if ammo_number < ammo_drop_chance:
		make_crate(ammo_crate)
	var health_number = rand_range(0,100)
	if health_number < health_drop_chance:
		make_crate(health_crate)
	queue_free()

func make_crate(type):
	var crate_instance = type.instance()
	match type:
		ammo_crate:
			crate_instance.ammo_amount = int(rand_range(ammo_return_min, ammo_return_max))
		health_crate:
			crate_instance.health_amount = 20
	crate_instance.global_transform.origin = global_transform.origin
	get_tree().get_root().add_child(crate_instance)

func _on_MoveTimer_timeout():
	can_change_direction = true

func _on_ExplosionRange_body_entered(body):
	if current_state == RAGE:
		GlobalGameHandler.player_health -= explosion_damage
		get_tree().call_group("HealthBar", "set_health")
		queue_free()

func _on_ShootTimer_timeout():
	can_shoot = true
