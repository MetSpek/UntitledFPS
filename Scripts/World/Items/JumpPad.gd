extends Spatial


var player
export var speedUp = 0
export var speedForward = 0


func _on_Area_body_entered(body):
	if body.name == "Player":
		player = body
		player.velocity = transform.basis.z.normalized()*speedForward
		player.velocity.y += speedUp
