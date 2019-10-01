shader_type canvas_item;
//render_mode blend_premul_alpha;

uniform float aura_width = 2.0;
uniform vec4 aura_color : hint_color = vec4(1.0,1.0,1.0,1.0);
uniform bool invisible;
uniform bool visible_only_on_outline;

uniform bvec4 north_south_east_west;
uniform bvec4 northwest_northeast_southwest_southeast;


bool process_north(vec2 ps, sampler2D texture, vec2 uv) {
	if(north_south_east_west.x) {
		float a = texture(texture, uv + vec2(0.0, -aura_width) * ps).a;
		return a <= 0.0;
	}
	return false;
}

bool process_north_east(vec2 ps, sampler2D texture, vec2 uv) {
	if(northwest_northeast_southwest_southeast.y) {
		float a = texture(texture, uv + vec2(aura_width, -aura_width) * ps).a;
		return a <= 0.0;
	}
	return false;
}

bool process_north_west(vec2 ps, sampler2D texture, vec2 uv) {
	if(northwest_northeast_southwest_southeast.x) {
		float a = texture(texture, uv + vec2(-aura_width, -aura_width) * ps).a;
		return a <= 0.0;
	}
	return false;
}


bool process_south(vec2 ps, sampler2D texture, vec2 uv) {
	if(north_south_east_west.y) {
		float a = texture(texture, uv + vec2(0.0, aura_width) * ps).a;
		return a <= 0.0;
	}
	return false;
}

bool process_south_west(vec2 ps, sampler2D texture, vec2 uv) {
	if(northwest_northeast_southwest_southeast.z) {
		float a = texture(texture, uv + vec2(-aura_width, aura_width) * ps).a;
		return a <= 0.0;
	}
	return false;
}

bool process_south_east(vec2 ps, sampler2D texture, vec2 uv) {
	if(northwest_northeast_southwest_southeast.w) {
		float a = texture(texture, uv + vec2(aura_width, aura_width) * ps).a;
		return a <= 0.0;
	}
	return false;
}


bool process_west(vec2 ps, sampler2D texture, vec2 uv) {
	if(north_south_east_west.w) {
		float a = texture(texture, uv + vec2(-aura_width, 0.0) * ps).a;
		return a <= 0.0;
	}
	return false;
}
bool process_east(vec2 ps, sampler2D texture, vec2 uv) {
	if(north_south_east_west.z) {
		float a = texture(texture, uv + vec2(aura_width, 0.0) * ps).a;
		return a <= 0.0;
	}
	return false;
}

bool no_directions() {
	return !(
	north_south_east_west.x || north_south_east_west.y || north_south_east_west.z || north_south_east_west.w
	|| northwest_northeast_southwest_southeast.x || northwest_northeast_southwest_southeast.y
	|| northwest_northeast_southwest_southeast.z || northwest_northeast_southwest_southeast.w
	);
}


void fragment() {
	vec4 col = texture(TEXTURE, UV);
	
	//if no direction - no highlight
	if(no_directions()) {
		COLOR = col;
		if(invisible || visible_only_on_outline) {
			COLOR.a = 0.0;
		}
	} else {
		col = texture(TEXTURE, UV);
		vec2 ps = TEXTURE_PIXEL_SIZE;
		if(col.a <= 0.0) {
			//if fragment is transparent - do not hightlight
			COLOR = col;
		} else if(process_north(ps, TEXTURE, UV) 
		|| process_north_east(ps, TEXTURE, UV)
		|| process_north_west(ps, TEXTURE, UV)
		|| process_south(ps, TEXTURE, UV)
		|| process_south_west(ps, TEXTURE, UV)
		|| process_south_east(ps, TEXTURE, UV)
		|| process_west(ps, TEXTURE, UV)
		|| process_east(ps, TEXTURE, UV)
		) {
			COLOR = aura_color;
		} else {
			COLOR = col;
			if(invisible) {
				COLOR.a = 0.0;
			}
		}
	}
}
