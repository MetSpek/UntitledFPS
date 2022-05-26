extends KinematicBody

enum {
	NORMAL,
	SURFING
}

var playerState

export var jumpImpulse = 6.0
export var gravity = -15.0
export var groundAcceleration = 300.0
onready var groundSpeedWalk = GlobalGameHandler.player_walk_speed
onready var groundSpeedRun = GlobalGameHandler.player_slide_speed
export var groundSpeedCrouch = 2.0
var groundSpeed = 10
export var airAcceleration = 500.0
export var airSpeedLimit = 1
export var groundFrictionNormal = 0.7
export var groundFrictionSliding = 0.99
var groundFriction = groundFrictionNormal

export var mouseSensitivity = 0.1

var velocity = Vector3.ZERO

var restartTransform
var restartVelocity

export var normal_height = 1
export var crouch_height = .5

export var normal_fov = 70
export var sprint_fov = 80
onready var camera = $YawAxis/Camera
onready var tween = $Tween


#SHOOTING
export var default_weapon_position : Vector3
export var ads_weapon_position : Vector3
const ADS_LERP = 20
onready var vertical_recoil = GlobalGameHandler.currently_holding.vertical_recoil
var vertical_heatmap =0
onready var horizontal_recoil = GlobalGameHandler.currently_holding.horizontal_recoil
var horizontal_heatmap = 0

onready var weap_anim_player = $WeaponAnimations

onready var reload_timer = $WeaponReloadTimer
onready var raycast = $YawAxis/Camera/Shooting
onready var hand = $YawAxis/Camera/Hand
onready var bullet_hole = preload("res://Scenes/Weapons/BulletHole.tscn")
export var bullet_hole_list = ["Walls", "Boxes", "Trees", "Rocks"]

onready var hitmark = $YawAxis/Camera/UI/Hitmark
onready var hitmark_sound = $HitmarkSound
onready var hitmark_timer = $YawAxis/Camera/UI/Hitmark/HitmarkTimer
onready var crosshair = $YawAxis/Camera/UI/Crosshair
onready var interaction_raycast = $YawAxis/Camera/Interaction
var is_interacting = false
var ads_fov = 50

#HEALTH
onready var health = GlobalGameHandler.player_health

func _ready():
	get_tree().call_group("HealthBar", "set_max_health")
	show_right_weapon()
	restartTransform = self.global_transform
	restartVelocity = self.velocity
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	playerState = NORMAL
	groundSpeed = groundSpeedWalk
	pass # Replace with function body.

func _physics_process(delta):
	health = GlobalGameHandler.player_health
	if playerState == NORMAL:
		move_player(delta)
	fire()
	check_ads(delta)
	check_interaction()

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		$YawAxis.rotate_x(deg2rad(event.relative.y * mouseSensitivity * -1))
		self.rotate_y(deg2rad(event.relative.x * mouseSensitivity * -1))

		# Clamp yaw to [-89, 89] degrees so you can't flip over
		var yaw = $YawAxis.rotation_degrees.x
		$YawAxis.rotation_degrees.x = clamp(yaw, -89, 89)    
	
	if Input.is_action_pressed("next_weapon"):
		switch_weapon(1)
	elif Input.is_action_pressed("previous_weapon"):
		switch_weapon(-1)

func move_player(delta):
	# Apply gravity, jumping, and ground friction to velocity
	if is_on_floor():
		# By using is_action_pressed() rather than is_action_just_pressed()
		# we get automatic bunny hopping.
		if Input.is_action_pressed("jump"):
			velocity.y = jumpImpulse
		else:
			velocity *= groundFriction

	velocity.y += gravity * delta
	
	# Compute X/Z axis strafe vector from WASD inputs
	var basis = $YawAxis/Camera.get_global_transform().basis
	var strafeDir = Vector3(0, 0, 0)
	if Input.is_action_pressed("move_forward"):
		strafeDir -= basis.z
	if Input.is_action_pressed("move_backward"):
		strafeDir += basis.z
	if Input.is_action_pressed("move_left"):
		strafeDir -= basis.x
	if Input.is_action_pressed("move_right"):
		strafeDir += basis.x
	strafeDir.y = 0
	strafeDir = strafeDir.normalized()
	
	# Figure out which strafe force and speed limit applies
	var strafeAccel = groundAcceleration if is_on_floor() else airAcceleration
	var speedLimit = groundSpeed if is_on_floor() else airSpeedLimit
	
	# Project current velocity onto the strafe direction, and compute a capped
	# acceleration such that *projected* speed will remain within the limit.
	var currentSpeed = strafeDir.dot(velocity)
	var accel = strafeAccel * delta
	accel = max(0, min(accel, speedLimit - currentSpeed))
	# Apply strafe acceleration to velocity and then integrate motion
	velocity += strafeDir * accel
	velocity = move_and_slide(velocity, Vector3.UP, true)
	
	if Input.is_action_just_pressed("sprint"):
		groundSpeed = groundSpeedRun
	elif Input.is_action_just_released("sprint"):
		groundSpeed = groundSpeedWalk
	
	if Input.is_action_just_pressed("crouch"):
		scale.y = crouch_height
		groundSpeed = groundSpeedCrouch
		groundFriction = groundFrictionSliding
	elif Input.is_action_just_released("crouch"):
		scale.y = normal_height
		groundSpeed = groundSpeedWalk
		groundFriction = groundFrictionNormal
	
	pass

func check_ads(delta):
	if Input.is_action_pressed("fire_weapon_2") and !reload_timer.time_left > 0:
		ads_zoom(delta, ads_weapon_position, normal_fov, ads_fov)
		
	else:
		ads_zoom(delta, default_weapon_position, ads_fov, normal_fov)

func check_interaction():
	if interaction_raycast.is_colliding():
		get_tree().call_group("UpgradePole", "glow")
		is_interacting = true
	else:
		get_tree().call_group("UpgradePole", "hide")
		is_interacting = false
	
	if is_interacting and Input.is_action_just_pressed("interacting"):
		get_tree().call_group("UpgradePole", "interact")

func ads_zoom(delta, vision, fov_from, fov_to):
	hand.transform.origin = hand.transform.origin.linear_interpolate(vision, ADS_LERP * delta)
	tween.interpolate_property(camera, "fov", camera.fov, fov_to, .1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func show_right_weapon():
	for gun in hand.get_children():
		if gun.name == GlobalGameHandler.currently_holding.name:
			gun.visible = true
		else:
			gun.visible = false

func switch_weapon(to):
	if reload_timer.time_left == 0:
		GlobalGameHandler.currently_holding_index += to
		if GlobalGameHandler.currently_holding_index < 0:
			GlobalGameHandler.currently_holding_index = GlobalGameHandler.weapons.size() - 1
		elif GlobalGameHandler.currently_holding_index >= GlobalGameHandler.weapons.size():
			GlobalGameHandler.currently_holding_index = 0
		GlobalGameHandler.switch_weapon()
		show_right_weapon()
		get_tree().call_group("HUD", "fired")
		get_tree().call_group("HUD", "reloaded")

func fire():
	if Input.is_action_pressed("fire_weapon") and !weap_anim_player.is_playing():
		if GlobalGameHandler.clip_size_current > 0:
			if not weap_anim_player.is_playing(): 
				vertical_heatmap += vertical_recoil
				raycast.rotation_degrees.x = clamp(vertical_heatmap, 0 , 10)
				
				horizontal_heatmap = -horizontal_heatmap
				horizontal_recoil = -horizontal_recoil
				horizontal_heatmap += horizontal_recoil
				raycast.rotation_degrees.y = horizontal_heatmap
				GlobalGameHandler.clip_size_current -= 1
				get_tree().call_group("HUD", "fired")
				if raycast.get_collider():
					var target = raycast.get_collider()
					if bullet_hole_list.has(target.name):
						var bullet_hole_instance = bullet_hole.instance()
						raycast.get_collider().add_child(bullet_hole_instance)
						bullet_hole_instance.global_transform.origin = raycast.get_collision_point()
						bullet_hole_instance.look_at(raycast.get_collision_point() + raycast.get_collision_normal(), Vector3.UP)
					elif target.is_in_group("Enemy"):
						if !target.is_dead:
							if target.has_method("aggrevate"):
								target.aggrevate()
							target.health -= GlobalGameHandler.currently_holding.damage
							DamageNumber.damage_number(GlobalGameHandler.currently_holding.damage, target.global_transform.origin, target)
							hitmark.visible = true
							hitmark_sound.play()
							hitmark_timer.start()
							target.impact_point = raycast.get_collision_normal()
			weap_anim_player.play(GlobalGameHandler.currently_holding.fire_animation)
		elif !weap_anim_player.is_playing():
			reload()
			
	elif Input.is_action_just_released("fire_weapon") and !weap_anim_player.is_playing():
		weap_anim_player.stop()

	elif !Input.is_action_pressed("fire_weapon"):
		if raycast.rotation_degrees.x > 0:
			raycast.rotation_degrees.x -= vertical_recoil
			horizontal_heatmap = 0
			vertical_heatmap = 0
			raycast.rotation_degrees.y = 0
	
	if Input.is_action_pressed("reload_weapon") and !weap_anim_player.is_playing() and GlobalGameHandler.clip_size_current < GlobalGameHandler.clip_size_max:
		reload()

func reload():
	raycast.rotation_degrees.x = 0
	hand.rotation_degrees.x = 0
	horizontal_heatmap = 0
	vertical_heatmap = 0
	raycast.rotation_degrees.y = 0
	if GlobalGameHandler.current_bullets > 0:
		if GlobalGameHandler.current_bullets < GlobalGameHandler.clip_size_max:
			GlobalGameHandler.to_reload_ammo = GlobalGameHandler.current_bullets
			GlobalGameHandler.current_bullets = 0
		elif GlobalGameHandler.clip_size_current > 0:
			GlobalGameHandler.to_reload_ammo = GlobalGameHandler.clip_size_max
			GlobalGameHandler.current_bullets = GlobalGameHandler.current_bullets - (GlobalGameHandler.clip_size_max - GlobalGameHandler.clip_size_current)
		else:
			GlobalGameHandler.current_bullets -= GlobalGameHandler.clip_size_max
			GlobalGameHandler.to_reload_ammo = GlobalGameHandler.clip_size_max
		get_tree().call_group("HUD", "fired")
		get_tree().call_group("HUD", "reloaded")
		weap_anim_player.play(GlobalGameHandler.weapon_reload_animation)
		reload_timer.start()

func _on_HitmarkTimer_timeout():
	hitmark.visible = false


func _on_WeaponReloadTimer_timeout():
	GlobalGameHandler.clip_size_current = GlobalGameHandler.to_reload_ammo
	get_tree().call_group("HUD", "fired")


func _on_WeaponAnimations_animation_finished(anim_name):
	if GlobalGameHandler.clip_size_current == 0:
		reload()
