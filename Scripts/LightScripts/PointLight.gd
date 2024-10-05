@tool
extends Node2D

@export var initial_size : float
@export var decreasing_speed : float
var current_size : float

# Called when the node enters the scene tree for the first time.
func _ready():
	current_size = initial_size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(current_size > 0):
		current_size -= decreasing_speed * delta
		scale = Vector2(current_size, current_size)
	else:
		current_size = initial_size
	pass
