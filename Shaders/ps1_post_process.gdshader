shader_type canvas_item;

//uniform sampler2D screen_texture: hint_screen_texture, repeat_disable, filter_nearest;


uniform sampler2D my_custom_screen;
uniform vec2 viewport_size = vec2(640,480);
uniform vec2 virtual_resolution = vec2(320,240);
//uniform vec2 virtual_resolution = vec2(160,120);


const float ps1_dither[16] = float[16](
	-4.0, 0.0, -3.0, 1.0,
	2.0, -2.0, 3.0, -1.0,
	-3.0, 1.0, -4.0, 0.0,
	3.0, -1.0, 2.0, -2.0
);

void fragment() {

	vec3 screen_color = texture(my_custom_screen, UV).rgb;

	vec2 virtual_pos = floor(FRAGCOORD.xy * (virtual_resolution / viewport_size));
	int x = int(mod(virtual_pos.x, 4.0));
	int y = int(mod(virtual_pos.y, 4.0));
	int index = y * 4 + x;

	float dither_offset = (ps1_dither[index] / 8.0);

	vec3 quantized_color = floor((screen_color * 255.0) / 8.0 + dither_offset) / 31.0;

	//COLOR = vec4(1);

	COLOR = vec4(quantized_color,1);

	//vec3 test =  texture(my_custom_screen, UV).xyz;

	//COLOR = vec4(test, 1);

    //COLOR = texture(my_custom_screen, UV);
}





