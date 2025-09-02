shader_type canvas_item;

// 全局变量
const float REPEAT = 5.0;

// 旋转矩阵
mat2 rot(float a) {
    float c = cos(a), s = sin(a);
    return mat2(vec2(c, s), vec2(-s, c));
}

// box sdf
float sdBox(vec3 p, vec3 b) {
    vec3 q = abs(p) - b;
    return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0);
}

float box(vec3 pos, float scale) {
    pos *= scale;
    float base = sdBox(pos, vec3(0.4, 0.4, 0.1)) / 1.5;
    pos.xy *= 5.0;
    pos.y -= 3.5;
    pos.xy *= rot(0.75);
    float result = -base;
    return result;
}

float box_set(vec3 pos, float iTime, float gTime) {
    vec3 pos_origin = pos;
    float result;

    pos = pos_origin;
    pos.y += sin(gTime * 0.4) * 2.5;
    pos.xy *= rot(0.8);
    float box1 = box(pos, 2.0 - abs(sin(gTime * 0.4)) * 1.5);

    pos = pos_origin;
    pos.y -= sin(gTime * 0.4) * 2.5;
    pos.xy *= rot(0.8);
    float box2 = box(pos, 2.0 - abs(sin(gTime * 0.4)) * 1.5);

    pos = pos_origin;
    pos.x += sin(gTime * 0.4) * 2.5;
    pos.xy *= rot(0.8);
    float box3 = box(pos, 2.0 - abs(sin(gTime * 0.4)) * 1.5);

    pos = pos_origin;
    pos.x -= sin(gTime * 0.4) * 2.5;
    pos.xy *= rot(0.8);
    float box4 = box(pos, 2.0 - abs(sin(gTime * 0.4)) * 1.5);

    pos = pos_origin;
    pos.xy *= rot(0.8);
    float box5 = box(pos, 0.5) * 6.0;

    pos = pos_origin;
    float box6 = box(pos, 0.5) * 6.0;

    result = max(max(max(max(max(box1, box2), box3), box4), box5), box6);
    return result;
}

float map(vec3 pos, float iTime, float gTime) {
    return box_set(pos, iTime, gTime);
}

void fragment() {
    // 屏幕分辨率
    vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;

    // fragCoord
    vec2 p = (FRAGCOORD.xy * 2.0 - resolution) / min(resolution.x, resolution.y);

    vec3 ro = vec3(0.0, -0.2, TIME * 4.0);
    vec3 ray = normalize(vec3(p, 1.5));
    ray.xy = ray.xy * rot(sin(TIME * 0.03) * 5.0);
    ray.yz = ray.yz * rot(sin(TIME * 0.05) * 0.2);

    float t = 0.1;
    vec3 col = vec3(0.0);
    float ac = 0.0;

    for (int i = 0; i < 99; i++) {
	    float gTime_local = TIME - float(i) * 0.01;

	    vec3 pos = ro + ray * t;
	    pos = mod(pos - 2.0, 4.0) - 2.0;

	    float d = box_set(pos, TIME, gTime_local); // 传进去
	    d = max(abs(d), 0.01);

	    ac += exp(-d * 23.0);
	    t += d * 0.55;
    }

    col = vec3(ac * 0.02);
    col += vec3(0.0, 0.2 * abs(sin(TIME)), 0.5 + sin(TIME) * 0.2);

    COLOR = vec4(col, 1.0 - t * (0.02 + 0.02 * sin(TIME)));
}
