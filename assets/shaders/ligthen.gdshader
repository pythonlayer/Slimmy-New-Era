shader_type canvas_item;

// Controls for color and style adjustments
uniform float brightness : hint_range(-1.0, 1.0, 0.1) = 0.2;
uniform float contrast : hint_range(-1.0, 1.0, 0.1) = 0.3;
uniform float saturation : hint_range(-1.0, 1.0, 0.1) = 0.2;

void fragment() {
    vec4 color = texture(TEXTURE, UV);

    // Adjust brightness
    color.rgb += brightness;

    // Adjust contrast
    color.rgb = (color.rgb - 0.5) * (1.0 + contrast) + 0.5;

    // Adjust saturation
    float gray = dot(color.rgb, vec3(0.3, 0.59, 0.11));
    color.rgb = mix(vec3(gray), color.rgb, 1.0 + saturation);

    // Set the final color
    COLOR = color;
}
