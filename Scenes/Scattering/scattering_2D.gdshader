shader_type canvas_item;

uniform float scale = 1.0;

#define TAU 6.28318530718
#define MAX_ITER 5


void fragment() {
    float time = TIME * 0.5 + 23.0; // 调整散射速度
    
    vec2 uv = UV;
    
    vec2 p;

    p = mod(uv * TAU * scale, TAU) - 250.0;

    
    vec2 i = vec2(p);
    float c = 1.0;
    float inten = 0.005;
    
    for (int n = 0; n < MAX_ITER; n++) {
        float t = time * (1.0 - (3.5 / float(n + 1)));
        i = p + vec2(cos(t - i.x) + sin(t + i.y),
                     sin(t - i.y) + cos(t + i.x));
        c += 1.0 / length(vec2(
            p.x / (sin(i.x + t) / inten),
            p.y / (cos(i.y + t) / inten)
        ));
    }
    
    c /= float(MAX_ITER);
    c = 1.17 - pow(c, 1.4);
    vec3 colour = vec3(pow(abs(c), 8.0));
    colour = clamp(colour + vec3(0.0, 0.35, 0.5), 0.0, 1.0);

    
    COLOR = vec4(colour, 1.0); // 输出到 2D
}

