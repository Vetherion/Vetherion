shader_type spatial;

uniform float time : hint_range(0.0, 5.0); // Patlama zamanı
uniform vec3 explosion_center; // Patlamanın merkezi
uniform float explosion_strength : hint_range(0.0, 2.0); // Patlama kuvveti

void vertex() {
    // Patlamanın merkezinden olan uzaklığı hesapla
    float dist = length(VERTEX - explosion_center);

    // Dalgalanma efekti ekleyerek patlamayı daha gerçekçi yap
    float wave = sin(dist * 10.0 - time * 10.0) * 0.1;

    // Patlamanın etkisini zamanla büyüt
    float explosion_effect = smoothstep(0.0, 1.0, time) * explosion_strength;

    // Vertexleri merkezden dışa doğru hareket ettir ve dalgalanma ekle
    VERTEX += normalize(VERTEX - explosion_center) * (explosion_effect * dist + wave);
}

void fragment() {
    // UV'yi merkeze al ve daire maskesi oluştur
    vec2 uv = UV - vec2(0.5);
    float dist = length(uv) * 2.0;

    // Kenarları yumuşat (QuadMesh'i yuvarlak hale getir)
    float alpha_mask = smoothstep(0.5, 0.45, dist);

    // Ateş rengi (sarıdan kırmızıya, sonra siyaha)
    vec3 fire_color = mix(vec3(1.0, 0.5, 0.0), vec3(1.0, 0.0, 0.0), smoothstep(0.0, 1.0, fract(time)));
    fire_color = mix(fire_color, vec3(0.0, 0.0, 0.0), smoothstep(0.5, 1.0, time));

    // Gürültü ekleyerek daha doğal bir görünüm sağla
    float noise = fract(sin(dot(UV * time, vec2(12.9898, 78.233))) * 43758.5453);

    // Opaklık ayarı (zamanla kaybolan ateş efekti)
    float alpha = smoothstep(1.0, 0.0, time) * (0.7 + 0.3 * noise) * alpha_mask;

    ALBEDO = fire_color;
    ALPHA = alpha;
}
