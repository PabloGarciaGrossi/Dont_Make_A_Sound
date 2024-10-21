extends Node2D
class_name LightMarker

@export var radius : float
@export var varySize : bool
@export var minSize = 0.8
@export var maxSize = 1.0
@export var radiusChangesize = 0.1
@export var turnOff : bool
var increasing = true


func assign_radius(r : float):
	radius = r
	
func _process(delta):
	if varySize:
		if increasing:
			radius += radiusChangesize * delta
			if radius >= maxSize - 0.02:
				increasing = false
		else:
			radius -= radiusChangesize * delta
			if radius <= minSize + 0.02:
				increasing = true
	elif turnOff:
		if radius > 0.0:
				radius -= radiusChangesize * delta
	
