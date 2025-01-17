shader_type canvas_item;

uniform float dissolve_amount : hint_range(0.0, 1.5) = 0.5;
uniform sampler2D noise_texture;
uniform vec4 edge_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);
uniform float edge_thickness : hint_range(0.0, 0.1) = 0.02; 

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    float noise_value = texture(noise_texture, UV).r;
    if (noise_value < dissolve_amount - edge_thickness) {
        discard;
    }
	
	float edge = smoothstep(dissolve_amount - edge_thickness, dissolve_amount, noise_value);
    COLOR = mix(edge_color, tex_color, edge);
}
