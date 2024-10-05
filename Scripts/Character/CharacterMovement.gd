extends CharacterBody2D

const SPEED = 300.0
const ACCEL = 2.0

var input: Vector2
func get_input():
	input.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	return input.normalized()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_input = get_input()
	
	velocity = lerp(velocity, player_input * SPEED, ACCEL * delta)
	move_and_slide()
	pass
