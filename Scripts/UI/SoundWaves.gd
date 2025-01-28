extends ColorRect
class_name SoundWavesUI

# Called when the node enters the scene tree for the first time.
func _ready():
	show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var light_positions = _get_light_positions()
	#var radius = _get_light_radius()
	var lights = _get_lights()
	var light_positions = []
	
	
	for i in range(lights.size()):
		light_positions.append(lights[i].get_global_transform_with_canvas().origin)

	material.set_shader_parameter("lights", light_positions)
	
	pass
	
func _get_light_positions():
	return get_tree().get_nodes_in_group("light").map(
		func(light: Node2D):
			return light.get_global_transform_with_canvas().origin
	)
	
func _get_lights():
	return get_tree().get_nodes_in_group("light").map(
		func(light: LightMarker):
			return light
	)

