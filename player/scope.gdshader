shader_type spatial;
render_mode unshaded, depth_test_disabled, cull_disabled;

uniform float radius : hint_range(0.0, 1.0) = 0.5;
uniform float border_softness : hint_range(0.0, 0.2) = 0.02;
uniform vec2 center = vec2(0.5, 0.5);
uniform vec4 background_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform bool correct_aspect_ratio = true;

void fragment() {
    // UV'yi merkeze göre ayarlama
    vec2 uv = SCREEN_UV - center;

    // Ekran en-boy oranını düzeltme (daha mükemmel daire için)
    if (correct_aspect_ratio) {
        float aspect_ratio = VIEWPORT_SIZE.x / VIEWPORT_SIZE.y;
        uv.x *= aspect_ratio;
    }

    // Noktanın merkeze olan uzaklığını hesaplama
    float dist = length(uv);

    // Daha keskin kenar için daha az yumuşatma kullanma
    float circle_mask = smoothstep(radius - border_softness, radius + border_softness, dist);

    // Arka planı siyah yap, ancak dairenin içinde şeffaf bırak
    ALBEDO = background_color.rgb;
    ALPHA = circle_mask * background_color.a;
}