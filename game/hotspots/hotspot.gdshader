shader_type canvas_item;

uniform vec4 line_color : source_color = vec4(1.0);
// uniform float line_thickness : hint_range(0, 10) = 1.0;
uniform float width: hint_range(0,10)  = 2.0;


const vec2 OFFSETS[8] = {
	vec2(-1,-1), vec2(-1,0), vec2(-1,1), vec2(0,-1),
	vec2(0,1), vec2(1,-1), vec2(1,0), vec2(1,1)
};

void vertex(){
	// start with adding margin to the original sprite
	// this will scale up the sprite, will scale down later in fragment()
	VERTEX += (UV * 2.0 - 1.0) * width ;
}

void fragment(){
	// note that TEXTURE_PIXEL_SIZE is actually 1.0/vec2(WIDTH_OF_TEXTURE, HEIGHT_OF_TEXTURE)
	// so 1.0 / TEXTURE_PIXEL_SIZE is vec2(WIDTH, HEIGHT)
	vec2 real_texture_size = 1.0 / TEXTURE_PIXEL_SIZE;
	
	// This is texture size when add margin equal to 
	// width of the outline*2 (left and right / top and down)
	vec2 added_margin_texture_pixel_size = 1.0 / (real_texture_size + (width*2.0));
	
	// width in range (0,1), respected to the new texture size
	vec2 width_size = added_margin_texture_pixel_size * width;
	// shift the original uv bottom-right for 'width' unit 
	// Calculate how much bigger is the new size compared to the old one
	vec2 shifted_uv = UV - width_size;
	// Then scale the uv down to that ratio
	vec2 ratio = TEXTURE_PIXEL_SIZE / added_margin_texture_pixel_size;
	vec2 scaled_shifted_uv = shifted_uv * ratio;
	
	// sample the original texture with new uv to scale it down
	// to the original size
	vec4 color;
	color = texture(TEXTURE, scaled_shifted_uv);
	// This if is to remove artifacts outside the boundary of sprites
	if (scaled_shifted_uv != clamp(scaled_shifted_uv, vec2(0.0), vec2(1.0))) {
		color.a = 0.0;
	}
	
	float outline = 0.0;
	for (int i=0; i<OFFSETS.length(); i++){
		outline += texture(TEXTURE, scaled_shifted_uv + OFFSETS[i]*width_size).a;
	}
	outline = min(outline, 1.0);
	
	COLOR = mix(color, line_color, outline-color.a);
}