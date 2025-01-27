
extends Node2D
@export var increasingVelocity : float
@export var deceleration : float 
@export var timer : float
@export var collisionDetector : PackedScene
@export var color : Color
var current_increasingVelocity : float
var center : Vector2
var radius : float
var start_angle : float
var end_angle : float
var point_count : int

var width : float = -1.0
var antialised : bool = false
var listOfCollisions : Array
var angle : float

#func _ready():
	#set_values(Vector2.ZERO)
	#for x in 100:
		#var tween = create_tween()
		#tween.tween_property(self, "radius", 100 + current_increasingVelocity, 2).set_ease((Tween.EASE_IN_OUT))
		#tween.tween_interval(2)
		#tween.tween_property(self, "radius", 50 + current_increasingVelocity, 2).set_ease((Tween.EASE_IN_OUT))
		#await  tween.finished

func set_values(pos : Vector2):
	center = pos
	antialised = true
	start_angle = 0
	end_angle = 360
	point_count = 36
	
	color = Color.WHITE
	width = 1
	current_increasingVelocity = increasingVelocity
	angle = end_angle / point_count
	
	for i in range(point_count):
		var newCollision = collisionDetector.instantiate()
		get_parent().add_child(newCollision)
		listOfCollisions.append(newCollision)
		newCollision.position = Vector2(center.x + radius * cos((angle * i)), 
										center.y + radius * sin((angle * i)))
		if i > 0:
			newCollision.setNextLightPosition(listOfCollisions[(i-1)])
		
	listOfCollisions[0].setNextLightPosition(listOfCollisions[point_count -1])

#func _draw():
	#for i in range(listOfCollisions.size() - 1):
		#if(listOfCollisions[i] != null and listOfCollisions[i+1] != null):
			#draw_line(listOfCollisions[i].position, listOfCollisions[i+1].position, color, width)
	
	#draw_arc(center, radius, start_angle, end_angle, point_count, color, width, antialised)


func _process(delta):
	if(current_increasingVelocity > 0):
		current_increasingVelocity -= deceleration * delta
		radius += current_increasingVelocity * delta
		
		for i in range(listOfCollisions.size()):
			if listOfCollisions[i] != null and !listOfCollisions[i].collided:
				listOfCollisions[i].position = Vector2(center.x + radius * cos((angle * i)), 
										center.y + radius * sin((angle * i)))
	else :
		#radius = 0
		#current_increasingVelocity = increasingVelocity
		for i in range(listOfCollisions.size()):
			if(listOfCollisions[i] != null and listOfCollisions[i].lightMarker.radius > 0):
				listOfCollisions[i].collided = true
				listOfCollisions[i].current_size = listOfCollisions[i].initial_size
		queue_free()
	queue_redraw()
	
