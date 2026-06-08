shader_type canvas_item;

uniform sampler2D main_render : source_color, filter_nearest, repeat_disable;
uniform sampler2D terraformed_render : source_color, filter_nearest, repeat_disable;
uniform sampler2D ui_render : source_color, filter_nearest, repeat_disable;
uniform sampler2D switch_render : source_color, filter_nearest, repeat_disable;

void fragment() {
	vec4 col_main = texture(main_render, SCREEN_UV);
	vec4 col_terra = texture(terraformed_render, SCREEN_UV);
	vec4 col_ui = texture(ui_render, SCREEN_UV);
	vec4 col_switch = texture(switch_render, SCREEN_UV);
	vec4 col = col_main;
	if (col_switch.rg == vec2(1.0))
		col = col_terra;
	col.rgb = mix(col.rgb, col_ui.rgb, col_ui.a);
	COLOR = col;
}