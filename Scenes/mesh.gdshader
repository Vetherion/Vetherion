shader_type spatial;

float random(vec3 pos) {
    return fract(sin(dot(pos, vec3(127.1, 311.7, 74.7))) * 43758.5453);
}

void fragment() {
    vec3 pos = vec3(UV * 1.0, TIME * 0.5); // Zamanla değişen gürültü
    float noise = random(pos); // Gürültü hesapla

    float bw = step(0.5, noise); // Siyah-beyaz efekt

    ALBEDO = vec3(bw);
}
