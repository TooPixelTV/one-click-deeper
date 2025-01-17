shader_type canvas_item;

uniform vec4 color: source_color;
uniform float amount: hint_range(0.0, 1.0, 0.01) = 0.5;
uniform float transparency_threshold: hint_range(0.0, 1.0, 0.01) = 0.01;

void fragment() {
	vec4 pixel = texture(TEXTURE, UV);
	if (pixel.a > transparency_threshold) {
		COLOR = mix(pixel, color, amount);
	}
}
