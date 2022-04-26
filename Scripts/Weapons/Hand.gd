extends Spatial



export var default_weapon_position : Vector3
export var ads_weapon_position : Vector3
const ADS_LERP = 20

func _process(delta):
	if Input.is_action_pressed("fire_weapon_2"):
		transform.origin = transform.origin.linear_interpolate(ads_weapon_position, ADS_LERP * delta)
	else:
		transform.origin = transform.origin.linear_interpolate(default_weapon_position, ADS_LERP * delta)
