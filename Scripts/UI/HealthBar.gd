extends Control

onready var health_over = $HealthBarOver
onready var health_under = $HealthBarUnder
onready var update_tween = $UpdateTween
onready var health_current = $HealthNumbers/HealthCurrent
onready var health_max = $HealthNumbers/HealthMax
var player


export (Color) var healthy_color = Color.green
export (Color) var caution_color = Color.yellow
export (Color) var danger_color = Color(0.784314, 0.223529, 0.223529)
export (Color) var shield_color = Color(0.066667, 0.337255, 0.854902)
export (float, 0, 1, 0.05) var caution_zone = 0.6
export (float, 0, 1, 0.05) var danger_zone = 0.3

func _ready():
	player = get_node("/root").find_node("PlayerTemplate", true, false)
	set_max_health()

func set_max_health():
	health_over.max_value = player.health
	health_under.max_value = player.health
	health_over.value = player.health
	health_under.value = player.health
	health_current.text = str(player.health)
	health_max.text = "/" + str(player.health)
	assign_color(player.health)


func set_health():
	health_over.value = player.health
	health_current.text = str(stepify(player.health, 1))
	update_tween.interpolate_property(health_under, "value", player.health, player.health, 1, Tween.TRANS_SINE, Tween.EASE_IN_OUT, .4)
	update_tween.start()
	assign_color(player.health)

func assign_color(health):
	if health < health_over.max_value * danger_zone:
		health_over.tint_progress = danger_color
		health_current.set("custom_colors/font_color", danger_color)
	elif health < health_over.max_value * caution_zone:
		health_over.tint_progress = caution_color
		health_current.set("custom_colors/font_color", caution_color)
	else: 
		health_over.tint_progress = healthy_color
		health_current.set("custom_colors/font_color", healthy_color)
