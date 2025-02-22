/*
    This shader was generated and customized with the help of ChatGPT.
    You are free to use, modify, and distribute it in commercial or non-commercial projects.
*/

shader_type spatial;

void fragment() {
    vec2 uv = UV * 10.0; // Grid density
    vec2 grid = abs(fract(uv - 0.5) - 0.5) / fwidth(uv);
    float line = min(grid.x, grid.y);
    float grid_color = 1.0 - smoothstep(0.0, 1.0, line);

    ALBEDO = vec3(grid_color);
    METALLIC = 0.0;  // No metallic reflection
    ROUGHNESS = 1.0; // Fully rough, no shine
}
