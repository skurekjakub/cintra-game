// HD-2D spike: "rolling cylinder" world bend (after The Adventures of Elliot's camera trick).
// Everything farther than the pivot (along the camera's horizontal forward) is wrapped onto a
// cylinder of radius bend_radius: the far floor drops away and far walls lean back to face the
// camera, so the background rises into view instead of the frame filling with floor.
// The near side stays flat. Use with render_mode world_vertex_coords.
uniform vec3 bend_pivot = vec3(0.0);
uniform vec3 bend_fwd = vec3(0.0, 0.0, -1.0);
uniform float bend_radius = 0.0;

float hd_bend_theta(vec3 w) {
	if (bend_radius <= 0.0) {
		return 0.0;
	}
	return max(dot(w - bend_pivot, bend_fwd), 0.0) / bend_radius;
}

vec3 hd_bend_point(vec3 w) {
	float th = hd_bend_theta(w);
	if (th <= 0.0) {
		return w;
	}
	vec3 rel = w - bend_pivot;
	float d = dot(rel, bend_fwd);
	vec3 side = rel - bend_fwd * d;
	side.y = 0.0;
	float r = bend_radius + rel.y;
	return bend_pivot + side + bend_fwd * (r * sin(th)) + vec3(0.0, r * cos(th) - bend_radius, 0.0);
}

vec3 hd_bend_dir(vec3 v, float th) {
	float f = dot(v, bend_fwd);
	vec3 side = v - bend_fwd * f;
	float u = side.y;
	side.y = 0.0;
	float c = cos(th);
	float s = sin(th);
	return side + bend_fwd * (f * c + u * s) + vec3(0.0, u * c - f * s, 0.0);
}
