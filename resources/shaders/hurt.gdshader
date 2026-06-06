shader_type canvas_item;

uniform float damage_amount : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	float edge = smoothstep(
		0.05,
		0.15,
		UV.x
	) *
	smoothstep(
		0.05,
		0.15,
		UV.y
	) *
	smoothstep(
		0.05,
		0.15,
		1.0 - UV.x
	) *
	smoothstep(
		0.05,
		0.15,
		1.0 - UV.y
	);

	vec3 damage_tint = vec3(1.0, 0.15, 0.15);

	vec3 color = tex.rgb;

	color = mix(
		color,
		damage_tint,
		damage_amount
	);

	color += (1.0 - edge) * damage_amount;

	COLOR = vec4(color, tex.a);
}