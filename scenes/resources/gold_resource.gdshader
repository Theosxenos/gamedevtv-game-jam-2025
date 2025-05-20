shader_type canvas_item;

void fragment() {
    // Get the current pixel color
    vec4 current_color = texture(TEXTURE, UV);
    
    // Calculate the intensity (luminance) of the original color
    // Using standard luminance formula: 0.299*R + 0.587*G + 0.114*B
    float intensity = dot(current_color.rgb, vec3(0.299, 0.587, 0.114));
    
    // Define our gold color (#FFD700)
    //vec3 gold_color = vec3(1.0, 0.843, 0.0);
    vec3 gold_color = vec3(1.0, 1.0, 0.0);
    
    // If the color is black (or very close to black), keep it as is
    // Otherwise, apply the gold color while maintaining intensity
    vec3 final_color;
    if (intensity < 0.05) {
        final_color = vec3(0.0, 0.0, 0.0); // Keep black
    } else {
        // Scale gold color by the original intensity to preserve brightness
        final_color = gold_color * intensity;
    }
    
    // Keep the original alpha value
    COLOR = vec4(final_color, current_color.a);
}