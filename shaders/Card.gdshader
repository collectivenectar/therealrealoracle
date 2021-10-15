shader_type canvas_item;

uniform vec4 card_color1;

void fragment(){
	COLOR = texture(TEXTURE, UV);
	COLOR.r = card_color1.r;
	COLOR.g = card_color1.g;
	COLOR.b = card_color1.b;
}
