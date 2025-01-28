shader_type canvas_item;

uniform vec2 lights[100];

vec4 line(vec2 p1, vec2 p2, float width, vec2 uv)
{
	float dist = distance(p1, p2); // Distance between points
	float dist_uv = distance(p1, uv); // Distance from p1 to current pixel

	// If point is on line, according to dist, it should match current UV
	// Ideally the '0.001' should be SCREEN_PIXEL_SIZE.x, but we can't use that outside of the fragment function.
	float color = 1.0 - floor(1.0 - (0.001 * width) + distance (mix(p1, p2, clamp(dist_uv / dist, 0.0, 1.0)),  uv));
	
	if(color == 0.0)
	{
		return vec4(0.0, 0.0, 0.0, 0.0);
	}
	
	return vec4(color, color, color, 1.0);
}

void fragment()
{
	vec2 point1 = vec2(0.45, 0.2);
	vec2 point2 = vec2(0.55, 0.5);
	vec2 point3 = vec2(0.45, 0.8);
	
	vec4 color  = vec4(line(point1, point2, 2.0, UV));
		 color += vec4(line(point2, point3, 2.0, UV));
	
	COLOR = vec4(color);
}
