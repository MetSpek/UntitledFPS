extends Spatial

func _on_Area_body_entered(body):
	GlobalGameHandler.select_next_level()
