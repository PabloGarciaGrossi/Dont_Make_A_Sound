extends Area2D

@export var light : PackedScene

func setPos(x : float, y: float):
	position = Vector2(x,y)



func _on_body_entered(body):
	if body.is_in_group("LightCollision"):
		var newLight = light.instantiate()
		add_child(newLight)
		newLight.position = position
		print("Collided with: ", body.name)
