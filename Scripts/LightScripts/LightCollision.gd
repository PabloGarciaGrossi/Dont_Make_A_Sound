extends Area2D

@export var light : PackedScene

@export var initial_size : float
@export var decreasing_speed : float

@export var lightMarker : LightMarker
var current_size : float

var collided = false
func setPos(x : float, y: float):
	position = Vector2(x,y)



func _on_body_entered(body):
	if body.is_in_group("LightCollision") && !collided:
		#var newLight = light.instantiate()
		#get_parent().get_parent().add_child(newLight)
		#newLight.position = position
		collided = true
		current_size = initial_size
		print("Collided with: ", body.name)

func reset():
	collided = false

	
func _process(delta):

	if(collided):
		if(current_size > 0):
			current_size -= decreasing_speed * delta
			#scale = Vector2(current_size, current_size)
			lightMarker.assign_radius(current_size)
		else:
			queue_free()
		pass
