extends Area2D

@export var light : PackedScene
var collided = false
func setPos(x : float, y: float):
	position = Vector2(x,y)



func _on_body_entered(body):
	if body.is_in_group("LightCollision") && !collided:
		var newLight = light.instantiate()
		get_parent().get_parent().add_child(newLight)
		newLight.position = position
		collided = true
		print("Collided with: ", body.name)

func reset():
	collided = false
