shader_type spatial;

uniform vec4 beam_color : source_color = vec4(0.2, 1.0, 0.1, 1.0);
uniform float speed = 2.0;
uniform float emission_strength = 5.0;

void fragment() {
    // Déplacement du motif
    float flow = fract(UV.y + TIME * speed);

    // Motif lumineux
    float glow = smoothstep(0.0, 0.5, flow)
               * smoothstep(1.0, 0.5, flow);

    ALBEDO = beam_color.rgb;
    EMISSION = beam_color.rgb * glow * emission_strength;
}