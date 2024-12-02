shader_type canvas_item;

// Screen
uniform sampler2D screen_texture : hint_screen_texture;

// CRT curvature
uniform float crt_curve : hint_range(0.0, 1.0) = 0.02;
// Scan line intensity
uniform float crt_scan_line_intensity : hint_range(0.0, 1.0) = 0.6;
// Brightness
uniform float brightness : hint_range(0.0, 2.0) = 1.2;
// Purple neon tint
uniform vec3 neon_tint = vec3(0.3, 0.0, 0.6); // Less intense purple
// RF Blur
uniform float rf_switch_esque_blur : hint_range(0.0, 1.0) = 0.3;
// White noise
uniform float white_noise_rate : hint_range(0.0, 1.0) = 0.1;
// Horizontal distortion factor for CRT lines
uniform float crt_line_distortion : hint_range(0.0, 1.0) = 0.05;

// Random noise function
float random(vec2 pos) { 
	return fract(sin(dot(pos, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	// CRT curvature adjustment
	vec2 crt_curve_shift = (vec2(1.0, 1.0) - sin(UV.yx * PI)) * crt_curve;
	vec2 crt_curve_scale = vec2(1.0, 1.0) + crt_curve_shift * 2.0;
	vec2 fixed_uv = SCREEN_UV * crt_curve_scale - crt_curve_shift;

	// Get texture color with curvature and RF blur
	vec3 color = texture(screen_texture, fixed_uv).rgb;
	color = mix(color, vec3(0.0), rf_switch_esque_blur * 0.5);

	// White noise effect
	float white_noise = random(fixed_uv + vec2(sin(TIME * 0.5), cos(TIME * 0.3)));
	color = mix(color, vec3(white_noise), white_noise_rate);

	// Add purple neon tint (reduced intensity)
	color = mix(color, neon_tint, 0.2); // Reduced blend factor to make purple less dominant

	// Horizontal scan lines (thicker and distorted)
	float line_pos = fixed_uv.y / SCREEN_PIXEL_SIZE.y + random(fixed_uv) * crt_line_distortion;
	float scan_line = mod(line_pos, 4.0) < 2.0 ? crt_scan_line_intensity : 1.0;
	color *= vec3(scan_line);

	// Final color
	COLOR.rgb = color * brightness;
	COLOR.a = 1.0;
}
