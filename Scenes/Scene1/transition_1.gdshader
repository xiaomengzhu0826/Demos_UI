shader_type canvas_item;

uniform float progress:hint_range(0.0, 1.0);
uniform bool is_reverse = true;
uniform vec2 num_of_tiles=vec2(16,9);

void fragment() {
	vec2 dis=abs(UV-0.5);
	float manhattan=dis.x+dis.y;

	if(is_reverse)
	{
		if(manhattan <= progress*1.0)
		{
			discard;
		}
	}else
	{
		if(manhattan >= progress*1.0)
		{
			discard;
		}
	}
}

