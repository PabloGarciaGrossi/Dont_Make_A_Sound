shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform vec2 lights[100];
uniform float lightsMarkerRadius[100];
uniform int number_of_lights = 1;
uniform vec4 modulate_color : source_color = vec4(0.0);


uniform float band_strength = 0.8;
uniform float band_radius = 54.0f;

uniform float max_light_radius = 128.0f;

float[2] distance_to_light(vec2 coords) {
	float dist = 1000.0;
	float light_radius = 0.0f;
	vec2 light_pos = vec2(0,0);
	for (int i = 0; i < number_of_lights; i++) {
		float new_dist = distance(coords, lights[i]);
		
		if(new_dist < dist){
			dist = new_dist;
			light_radius = lightsMarkerRadius[i];
			light_pos = lights[i];
		}
	}
	float returned [2];
	returned[0] = dist;
	returned[1] = light_radius; 
	
	return returned;
}

vec4 modulate(vec4 color, float[2] distance_and_radius_of_light){
	vec4 moduled = color * modulate_color;

	if(distance_and_radius_of_light[0] > distance_and_radius_of_light[1] * max_light_radius)
	{
		return moduled;
	}
	
	if(distance_and_radius_of_light[0] >= distance_and_radius_of_light[1] * band_radius)
	{
		return mix(moduled, color, band_strength);
	}
	

	return color;
}

vec4 myColorFunc(vec4 color, vec2 coords)
{
	vec4 moduled = color * modulate_color;
	
	for (int i = 0; i < number_of_lights; i++) {
		float new_dist = distance(coords, lights[i]);
		
		if(new_dist < max_light_radius * lightsMarkerRadius[i] && new_dist > band_radius * lightsMarkerRadius[i]){
			moduled = mix(moduled, color, band_strength);
		}
		else if(new_dist < band_radius * lightsMarkerRadius[i]){
			moduled = mix(moduled, color, max_light_radius * lightsMarkerRadius[i] / new_dist);
			moduled = clamp(moduled, vec4(0.0), color);
		}
		

	}
	
	return moduled;
}
void fragment() {
	// Called for every pixel the material is visible on.
	COLOR = texture(screen_texture, SCREEN_UV);

	vec4 color = myColorFunc(COLOR, FRAGCOORD.xy);
	COLOR = color;
	
}





//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
