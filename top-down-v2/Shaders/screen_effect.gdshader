shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
uniform float crt_curve : hint_range(0.0, 1.0) = 0.02; // Curvature of the CRT glass
uniform float crt_scan_line_color : hint_range(0.0, 1.0) = 0.347; // Scanline darkness
uniform float crt_line_intensity : hint_range(0.0, 1.0) = 0.5; // Control the intensity of the scanlines
uniform float crt_line_thickness : hint_range(0.0, 1.0) = 0.2; // Control the thickness of the scanlines
uniform float aperture_grille_rate : hint_range(0.0, 1.0) = 0.4; // Aperture grille intensity
uniform float rf_switch_esque_blur : hint_range(0.0, 1.0) = 1.0; // RF blur effect
uniform float white_noise_rate : hint_range(0.0, 1.0) = 0.0; // White noise intensity
uniform float neon_glow_strength : hint_range(0.0, 1.0) = 0.4; // Neon purple glow strength
uniform float scanline_scroll_speed : hint_range(0.0, 1.0) = 0.1; // Speed of scanline scrolling

float random(vec2 pos)
{
    return fract(sin(dot(pos, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment()
{
    // Apply CRT curvature effect
    vec2 crt_curve_shift = (vec2(1.0, 1.0) - sin(UV.yx * PI)) * crt_curve;
    vec2 crt_curve_scale = vec2(1.0, 1.0) + crt_curve_shift * 2.0;
    vec2 texture_fixed_uv = UV * crt_curve_scale - crt_curve_shift;
    vec2 fixed_uv = SCREEN_UV * crt_curve_scale - crt_curve_shift;

    // Check if UV is within the texture bounds
    float enable_color = float(0.0 <= texture_fixed_uv.x && texture_fixed_uv.x <= 1.0 && 0.0 <= texture_fixed_uv.y && texture_fixed_uv.y <= 1.0);

    // Get the color from the screen texture with RF-like blur
    COLOR.rgb = (texture(screen_texture, fixed_uv).rgb * (1.0 - rf_switch_esque_blur * 0.5)) + (
        (texture(screen_texture, fixed_uv + vec2(-SCREEN_PIXEL_SIZE.x * 3.1, 0.0)).rgb +
         texture(screen_texture, fixed_uv + vec2(SCREEN_PIXEL_SIZE.x * 3.1, 0.0)).rgb) * (rf_switch_esque_blur * 0.25)
    );
    COLOR.a = 1.0;

    // White noise effect to simulate graininess
    vec2 aperture_grille_pixel = vec2(floor((fixed_uv.x / SCREEN_PIXEL_SIZE.x) / 3.0) * 3.0, fixed_uv.y);
    float white_noise = random(aperture_grille_pixel + vec2(sin(TIME * 0.543254), cos(TIME * 0.254323563)));
    COLOR.rgb = mix(COLOR.rgb, vec3(white_noise, white_noise, white_noise), white_noise_rate * enable_color);

    // Aperture grille effect
    float aperture_grille_point = mod(((SCREEN_UV.x * crt_curve_scale.x) - crt_curve_shift.x) / SCREEN_PIXEL_SIZE.x, 3.0);
    float aperture_grille_r_rate = clamp(1.0 - aperture_grille_point, 0.0, 1.0) + clamp(aperture_grille_point - 2.0, 0.0, 1.0);
    float aperture_grille_g_rate = clamp(1.0 - abs(1.0 - aperture_grille_point), 0.0, 1.0);
    float aperture_grille_b_rate = 1.0 - aperture_grille_r_rate - aperture_grille_g_rate;

    // Applying aperture grille with adjustable intensity
    COLOR.rgb = clamp(COLOR.rgb * vec3(
        clamp(aperture_grille_r_rate, aperture_grille_rate, 1.0),
        clamp(aperture_grille_g_rate, aperture_grille_rate, 1.0),
        clamp(aperture_grille_b_rate, aperture_grille_rate, 1.0)
    ), vec3(0.0), vec3(1.0));

    // Corrected scanline effect with adjustable thickness and scrolling animation
    float scanline_thickness = 0.025 + (crt_line_thickness * 0.025); // Restoring the previous approach for thickness
    float scroll_offset = mod(SCREEN_UV.y + (TIME * scanline_scroll_speed), scanline_thickness); // Vertical scrolling

    // Apply the scanline effect based on scrolling
    if (scroll_offset < scanline_thickness * 0.5) {
        COLOR.rgb = mix(COLOR.rgb, vec3(0.0, 0.0, 0.0), crt_scan_line_color * crt_line_intensity); // Apply the scanline color
    }

    // Apply neon purple glow by enhancing the purple hues
    vec3 neon_purple = vec3(0.7, 0.0, 1.0);
    COLOR.rgb = mix(COLOR.rgb, neon_purple, neon_glow_strength);

    // Output final color
    COLOR.a = 0.8; // Adjust alpha for transparency, allowing the background to show through
}
