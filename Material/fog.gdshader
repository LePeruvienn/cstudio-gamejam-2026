shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D noise_texture : source_color;

uniform vec4 fog_color : source_color = vec4(0.55, 0.65, 0.7, 1.0);

uniform float fog_density : hint_range(0.0, 1.0) = 0.35;
uniform float fog_start : hint_range(0.0, 1.0) = 0.0;
uniform float fog_end : hint_range(0.0, 1.0) = 1.0;

uniform bool use_noise = true;

uniform float noise_strength : hint_range(0.0, 1.0) = 0.2;
uniform float noise_scale : hint_range(0.1, 10.0) = 2.0;
uniform float noise_speed : hint_range(0.0, 5.0) = 0.2;

uniform float fog_contrast : hint_range(0.1, 5.0) = 1.0;


void fragment() {
    // Image originale
    vec4 screen_color = texture(screen_texture, SCREEN_UV);

    // --------------------------------------------------
    // NOISE
    // --------------------------------------------------

    float noise = 1.0;

    if (use_noise) {
        vec2 noise_uv = SCREEN_UV * noise_scale;

        noise_uv += vec2(
            TIME * noise_speed,
            TIME * noise_speed * 0.5
        );

        noise = texture(noise_texture, noise_uv).r;

        noise = mix(
            1.0,
            noise,
            noise_strength
        );
    }

    // --------------------------------------------------
    // DISTANCE DE BRUME
    // --------------------------------------------------

    float fog_factor = smoothstep(
        fog_start,
        fog_end,
        SCREEN_UV.y
    );

    // --------------------------------------------------
    // DENSITÉ
    // --------------------------------------------------

    fog_factor *= fog_density;

    // Noise
    fog_factor *= noise;

    // Contraste
    fog_factor = pow(
        fog_factor,
        fog_contrast
    );

    fog_factor = clamp(
        fog_factor,
        0.0,
        1.0
    );

    // --------------------------------------------------
    // MELANGE
    // --------------------------------------------------

    COLOR = mix(
        screen_color,
        fog_color,
        fog_factor
    );
}