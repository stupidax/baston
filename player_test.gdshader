shader_type canvas_item;
uniform float opacity: hint_range(0.0, 1.0);
uniform float r: hint_range(0.0, 1.0);
uniform float g: hint_range(0.0, 1.0);
uniform float b: hint_range(0.0, 1.0);
uniform float mix_color: hint_range(0.0, 1.0);

void vertex() {
	
}

void fragment() {
	// Se llama así por cada píxel en el que el material es visible.
	vec4 texture_color = texture(TEXTURE, UV);
	if (texture_color.a != 0.0)
		COLOR = vec4(mix(texture_color.rgb, vec3(r,g,b), mix_color), opacity);
}

void light() {
	// Se llama para cada píxel de cada luz que afecta al CanvasItem.
	float cNdotL = max(1.0, dot(NORMAL, LIGHT_DIRECTION));
	LIGHT = vec4(LIGHT_COLOR.rgb * COLOR.rgb * LIGHT_ENERGY * cNdotL, LIGHT_COLOR.a);
}
