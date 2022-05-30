extends Spatial


onready var raycaster = $Raycasts/RayCast
onready var animations = $Animations
onready var audio = $Audio
onready var reload = $Reload

const NAME = "Start Pistol"

var clipSizes = [7,10,13,16,19,22,25,28,31,34,37]
var clipSizeMax = clipSizes[GlobalGameHandler.startPistolAmmoLevel]
var currentBullets

var damageList = [6,7,8,9,10,11,12,13,14,15,16]
var damage = damageList[GlobalGameHandler.startPistolDamageLevel]

onready var bullet_hole = preload("res://Scenes/Weapons/BulletHole.tscn")
export var bullet_hole_list = ["Walls", "Boxes", "Trees", "Rocks"]


func _ready():
	if GlobalGameHandler.currentStartPistolClip == null:
		currentBullets = clipSizeMax
		GlobalGameHandler.currentStartPistolClip= currentBullets
	else:
		currentBullets = GlobalGameHandler.currentStartPistolClip
	update_hud()

func selected():
	update_hud()

func fire():
	if !animations.is_playing():
		if currentBullets > 0:
			currentBullets -= 1
			animations.play("PistolFire")
			if !audio.playing:
				audio.play()
			check_if_hit()
			update_hud()
			save_bullets()
		else:
			if !animations.is_playing() and reload.time_left == 0:
				reload()

func add_bullet_hole(target):
	var bullet_hole_instance = bullet_hole.instance()
	raycaster.get_collider().add_child(bullet_hole_instance)
	bullet_hole_instance.global_transform.origin = raycaster.get_collision_point()
	bullet_hole_instance.look_at(raycaster.get_collision_point() + raycaster.get_collision_normal(), Vector3.UP)

func check_if_hit():
	if raycaster.get_collider():
			var target = raycaster.get_collider()
			if target.is_in_group("Enemy"):
				hit_enemy(target)
			elif bullet_hole_list.has(target.name):
				add_bullet_hole(target)

func hit_enemy(target):
	if !target.is_dead:
		get_tree().call_group("HUD", "show_hitmark")
		if target.has_method("aggrevate"):
			target.aggrevate()
		target.health -= damage

func release():
	audio.stop()


func reload():
	release()
	if reload.time_left == 0:
		animations.play("PistolReload")
		reload.start()

func save_bullets():
	GlobalGameHandler.currentStartPistolClip = currentBullets

func _on_Reload_timeout():
	currentBullets = clipSizeMax
	update_hud()
	save_bullets()

func update_hud():
	get_tree().call_group("HUD", "fired", currentBullets)
	get_tree().call_group("HUD", "start_pistol")
	
 
