shader_type canvas_item;

uniform vec4 color_1 = vec4(.0, .0, .0, 1.0);
uniform vec4 color_2 = vec4(0.5, 0.5, 0.5, 1.0);
uniform vec4 color_3 = vec4(0.5, 0.5, 0.5, 1.0);
uniform vec4 color_4 = vec4(0.5, 0.5, 0.5, 1.0);
uniform vec4 color_5 = vec4(0.5, 0.5, 0.5, 1.0);
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear;
void fragment() {

	vec4 colors[5] = {color_1, color_2, color_3, color_4, color_5};
	float min_diff = -1.0;
	vec4 min_color = vec4(0.0, 0.0, 0.0, 1.0);

	vec2 uv = SCREEN_UV;

	vec4 temp = textureLod(SCREEN_TEXTURE, uv, 0.0);

	min_diff = 1000.0;
	for (int i = 0; i < colors.length(); i++) {

		float curr_dist = distance(colors[i], temp);
		if (curr_dist < min_diff) {
			min_diff = curr_dist;
			min_color = colors[i];
		}
	}

	COLOR.rgb = min_color.rgb;
}