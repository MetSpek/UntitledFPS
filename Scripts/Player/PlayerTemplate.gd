extends KinematicBody

#MOVEMENT
export var walk_speed = 15
export var sprint_speed = 25
export var crouch_speed = 5
export var slide_movement_speed = 35
var slide_speed = slide_movement_speed
var speed

export var crouching_speed = 20
export var slide_treshhold = 16

export var sliding_speed = 20

export var normal_height = 1.5
export var crouch_height = 0
export var slide_height = -2


var h_acceleration = 6
var air_acceleration = 1
var normal_acceleration = 6
export var gravity = 20
export var jump = 10
var full_contact = false

export var mouse_sensitivity = 0.05
export var normal_fov = 70
export var sprint_fov = 70

var direction = Vector3()
var h_velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()

onready var head = $Head
onready var camera = $Head/Camera
onready var ground_check = $GroundCheck
onready var tween = $Tween


#SHOOTING
onready var weap_anim_player = $Head/Camera/Hand/WeaponAnimationPlayer
export var clip_size_max = 2
var clip_size_current = clip_size_max
onready var reload_timer = $Head/Camera/Hand/ReloadTimer
onready var raycast = $Head/Camera/RayCast
onready var bullet_hole = preload("res://Scenes/Weapons/BulletHole.tscn")
export var bullet_hole_list = ["Walls", "Floors"]

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	speed = walk_speed

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
		
func _physics_process(delta):
	move_player(delta)
	fire()

func fire():
	if Input.is_action_pressed("fire_weapon") and !weap_anim_player.is_playing():
		if clip_size_current > 0:
			if not weap_anim_player.is_playing():
				clip_size_current -= 1
				if raycast.get_collider():
					if bullet_hole_list.has(raycast.get_collider().name):
						var bullet_hole_instance = bullet_hole.instance()
						raycast.get_collider().add_child(bullet_hole_instance)
						bullet_hole_instance.global_transform.origin = raycast.get_collision_point()
						bullet_hole_instance.look_at(raycast.get_collision_point() + raycast.get_collision_normal(), Vector3.UP)
			weap_anim_player.play("ShotgunFire")
		else:
			reload()
			
	elif Input.is_action_just_released("fire_weapon") and !weap_anim_player.is_playing():
		weap_anim_player.stop()
	
	if Input.is_action_pressed("reload_weapon") and !weap_anim_player.is_playing():
		reload()

func reload():
	weap_anim_player.play("ShotgunReload")
	reload_timer.start()

func _on_ReloadTimer_timeout():
	clip_size_current = clip_size_max

func move_player(delta):
	direction = Vector3()
	
	full_contact = ground_check.is_colliding()
	
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * delta
		h_acceleration = air_acceleration
	elif is_on_floor() and full_contact:
		gravity_vec = -get_floor_normal() * gravity
		h_acceleration = normal_acceleration
	else:
		gravity_vec = -get_floor_normal()
		h_acceleration = normal_acceleration
		
	if Input.is_action_just_pressed("jump") and (is_on_floor() or ground_check.is_colliding()):
		head.translation.y  += crouching_speed * delta
		head.translation.y  = clamp(head.translation.y, crouch_height, normal_height)
		gravity_vec = Vector3.UP * jump
	
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	
	if Input.is_action_just_pressed("sprint") and !Input.is_action_pressed("crouch"):
		tween.interpolate_property(camera, "fov", normal_fov, sprint_fov, .1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		speed = sprint_speed
	elif Input.is_action_just_released("sprint"):
		tween.interpolate_property(camera, "fov", sprint_fov, normal_fov, .1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		speed = walk_speed
	
	if Input.is_action_pressed("crouch") and is_on_floor():
		if h_velocity.z < -slide_treshhold or h_velocity.z > slide_treshhold or h_velocity.x < -slide_treshhold or h_velocity.x > slide_treshhold:
			head.translation.y -= crouching_speed * delta
			head.translation.y  = clamp(head.translation.y, slide_height, normal_height)
			slide_speed -= 0.1
			speed = slide_speed
		else:
			speed = crouch_speed
			slide_speed = slide_movement_speed
			head.translation.y -= crouching_speed * delta
			head.translation.y  = clamp(head.translation.y, crouch_height, normal_height)
	elif Input.is_action_just_released("crouch"):
		tween.interpolate_property(head, "translation:y", crouch_height, normal_height, .1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		speed = walk_speed
		
	
	
	
	direction = direction.normalized()
	h_velocity = h_velocity.linear_interpolate(direction * speed, h_acceleration * delta)
	movement.z = h_velocity.z + gravity_vec.z
	movement.x = h_velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	
	move_and_slide(movement, Vector3.UP)



