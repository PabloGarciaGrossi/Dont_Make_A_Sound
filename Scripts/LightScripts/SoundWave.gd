
extends Node2D
@export var increasingVelocity : float
@export var deceleration : float 
@export var collisionDetector : PackedScene

var current_increasingVelocity : float
var center : Vector2
var radius : float
var start_angle : float
var end_angle : float
var point_count : int
var color : Color
var width : float = -1.0
var antialised : bool = false
var listOfCollisions : Array
var angle : float

func _ready():
	set_values(Vector2.ZERO)
	#for x in 100:
		#var tween = create_tween()
		#tween.tween_property(self, "radius", 100, 2).set_ease((Tween.EASE_IN_OUT))
		#tween.tween_interval(2)
		#tween.tween_property(self, "radius", 50, 2).set_ease((Tween.EASE_IN_OUT))
		#await  tween.finished

func set_values(pos : Vector2):
	center = pos
	antialised = true
	start_angle = 0
	end_angle = 360
	point_count = 30
	color = Color.WHITE
	width = 5
	current_increasingVelocity = increasingVelocity
	angle = end_angle / point_count
	
	for i in range(point_count):
		var newCollision = collisionDetector.instantiate()
		add_child(newCollision)
		print(newCollision)
		listOfCollisions.append(newCollision)
		newCollision.position = Vector2(position.x + radius * cos((angle * i)), 
										position.y + radius * sin((angle * i)))
		
		
	
	
func _draw():
	draw_arc(center, radius, start_angle, end_angle, point_count, color, width, antialised)
	
func _process(delta):
	if(current_increasingVelocity > 0):
		current_increasingVelocity -= deceleration * delta
		radius += current_increasingVelocity * delta
		
		for i in range(listOfCollisions.size()):
			if listOfCollisions[i] != null:
				listOfCollisions[i].position = Vector2(position.x + radius * cos((angle * i)), 
										position.y + radius * sin((angle * i)))
	else :
		radius = 0
		current_increasingVelocity = increasingVelocity
	queue_redraw()
	
