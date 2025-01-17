shader_type canvas_item;

uniform float wave_speed : hint_range(0.1, 5.0) = 1.0;
uniform float wave_intensity : hint_range(0.0, 1.0) = 0.3;
uniform float wave_frequency : hint_range(1.0, 20.0) = 10.0;

void fragment() {
    // Coordonnées de texture UV
    vec2 uv = UV;

    // Appliquer une déformation ondulatoire sur les coordonnées UV
    float wave = sin(uv.y * wave_frequency + TIME * wave_speed) * wave_intensity;
    uv.x += wave;
	
	// Assurer que les coordonnées UV restent dans des limites valides
    if (uv.x < 0.0 || uv.x > 1.0) {
        discard;  // Supprime les pixels en dehors de la texture
    }

    // Échantillonner la texture avec les coordonnées UV déformées
    vec4 tex_color = texture(TEXTURE, uv);

    // Appliquer la couleur de la texture au fragment
    COLOR = tex_color;
}
