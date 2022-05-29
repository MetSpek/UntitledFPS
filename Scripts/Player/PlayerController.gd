extends KinematicBody

enum {
	NORMAL,
	SURFING,
	DEAD
}

var playerState

export var jumpImpulse = 6.0
export var gravity = -15.0
export var groundAcceleration = 300.0
onready var groundSpeedWalk = GlobalGameHandler.player_walk_speed * (Upgrades.moveSpeed.procentile / 100.0)
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
onready var weaponList = GlobalGameHandler.weapons
var currentlyHolding
onready var hand = $YawAxis/Camera/Hand

onready var interaction_raycast = $YawAxis/Camera/Interaction
var is_interacting = false
var ads_fov = 50

#HEALTH
onready var health = GlobalGameHandler.player_health

func _ready():
	add_weapons_to_player_at_start()
	get_tree().call_group("HealthBar", "set_max_health")
	restartTransform = self.global_transform
	restartVelocity = self.velocity
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	playerState = NORMAL
	groundSpeed = groundSpeedWalk
	pass # Replace with function body.

func _physics_process(delta):
	if playerState != DEAD:
		health = GlobalGameHandler.player_health
		if playerState == NORMAL:
			move_player(delta)
		fire()
		reload()
		zoom()
		check_interaction()
		if GlobalGameHandler.player_health <= 0:
			playerState = DEAD
			get_tree().call_group("HUD", "game_over")
		else:
			if playerState != NORMAL:
				playerState = NORMAL

func _input(event):
	if playerState != DEAD:
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



func check_interaction():
	if interaction_raycast.is_colliding():
		get_tree().call_group("UpgradePole", "glow")
		is_interacting = true
	else:
		get_tree().call_group("UpgradePole", "hide")
		is_interacting = false
	
	if is_interacting and Input.is_action_just_pressed("interacting"):
		get_tree().call_group("UpgradePole", "interact")


func add_weapons_to_player_at_start():
	for weapon in weaponList:
		add_weapon_to_player(weapon)
	switch_weapon(0)

func add_weapon_to_player(weapon):
	var weap = weapon.instance()
	hand.add_child(weap)
	currentlyHolding = weap

func switch_weapon(to):
	if currentlyHolding:
		if currentlyHolding.reload != null:
			if currentlyHolding.reload.time_left == 0:
				if not currentlyHolding.animations.is_playing() and not Input.is_action_pressed("fire_weapon"):
					if currentlyHolding.has_method("save_bullets"):
						currentlyHolding.save_bullets()
					GlobalGameHandler.currently_holding_index += to
					if GlobalGameHandler.currently_holding_index < 0:
						GlobalGameHandler.currently_holding_index = GlobalGameHandler.weapons.size() - 1
					elif GlobalGameHandler.currently_holding_index >= GlobalGameHandler.weapons.size():
						GlobalGameHandler.currently_holding_index = 0
					if hand.get_children()[GlobalGameHandler.currently_holding_index]:
						currentlyHolding = hand.get_children()[GlobalGameHandler.currently_holding_index]
					if currentlyHolding.has_method("selected"):
						currentlyHolding.selected()
		show_right_weapon()

func show_right_weapon():
	for gun in hand.get_children():
		if gun.name == currentlyHolding.name:
			gun.visible = true
		else:
			gun.visible = false

func fire():
	if currentlyHolding:
		if Input.is_action_pressed("fire_weapon"):
			if currentlyHolding.has_method("fire"):
				currentlyHolding.fire()
		elif Input.is_action_just_released("fire_weapon"):
			if currentlyHolding.has_method("release"):
				currentlyHolding.release()

func reload():
	if Input.is_action_just_pressed("reload_weapon"):
		if currentlyHolding.has_method("reload"):
			currentlyHolding.reload()

func reload_weapon():
	if currentlyHolding.has_method("reload"):
		currentlyHolding.reload()

func zoom():
	if currentlyHolding:
		if Input.is_action_pressed("fire_weapon_2") and currentlyHolding.reload.time_left == 0:
			ads_zoom(normal_fov, ads_fov)
		elif Input.is_action_just_released("fire_weapon_2"):
			ads_zoom(ads_fov, normal_fov)

func ads_zoom(fov_from, fov_to):
	tween.interpolate_property(camera, "fov", camera.fov, fov_to, .1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
