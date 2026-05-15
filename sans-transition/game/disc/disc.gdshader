shader_type canvas_item;


uniform float positions[4];
uniform float angle = 0.0;
varying float z;

vec2 rotate(vec2 v, float a) {
	float s = sin(a);
	float c = cos(a);
	mat2 m = mat2(vec2(c, s), vec2(-s, c));
	return m * v;
}

void vertex() {
	VERTEX /= positions[VERTEX_ID];
	z = positions[VERTEX_ID];
}

void fragment() {
	vec2 rotated_uv = rotate((UV * z - 0.5), angle);
	rotated_uv += 0.5;
	//rotated_uv = clamp(rotated_uv, vec2(-1.0), vec2(1.0));
	COLOR = texture(TEXTURE, rotated_uv);
	if (length(rotated_uv - 0.5) > .5) {
		discard;
	}
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
