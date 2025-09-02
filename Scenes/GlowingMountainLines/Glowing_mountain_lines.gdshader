shader_type canvas_item;

void fragment() {
    float a, d;
    float i = 0.0;
    vec3 o = vec3(0.0);
    vec3 p;

    // 屏幕分辨率
    vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec3 Z = vec3(resolution, 1.0);

    // fragCoord: 转换 UV (0-1) 到像素坐标
    vec2 C = FRAGCOORD.xy;

    // 光线方向 (camera ray direction)
    vec3 I = normalize(vec3(C - 0.5 * Z.xy, Z.y));

    // Raymarch loop
    Z = vec3(0.0, 0.0, fract(-TIME) / I.z);
	for (int step = 0; step < 60; step++) {
    	i += 1.0;
    	Z += 1.0 / abs(I);
		        for (int j = 0; j < 3; j += 2) {
            // World position
            p = Z[j] * I;
            p.z += TIME;
            p *= 0.2;
            d = p.y;
            a = 0.6;
            vec4 O = 1.0 + sin(0.5 * p.x + p.z + vec4(2.0, 1.0, 0.0, 2.0));

            // Fractal noise (3 octaves)
            for (int k = 1; k < 4; k++) {
                d += a + a * dot(sin(p), cos(p * 1.618).yzx);
                a *= 0.5;
                p.yz *= 0.2 * mat2(vec2(6.0, 8.0), vec2(-8.0, 6.0));
                p = p.yzx;
		}



            // Distance field + fog
            d = abs(d) + 5e-4 / (I[j] * I[j]) + 0.01 * smoothstep(10.0, 60.0, Z[j]);

            // Volumetric accumulation
            o += O.w / d * O.xyz * smoothstep(60.0, 40.0, Z[j]);
        }
    }

    // Tone mapping
    COLOR.rgb = tanh(o / 500.0);
    COLOR.a = 1.0;
}