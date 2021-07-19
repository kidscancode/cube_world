extends CubeBase

var last_dir =  Vector3.BACK

var move_dirs = [
	Vector3.RIGHT, Vector3.LEFT,
	Vector3.FORWARD, Vector3.BACK
]

func _physics_process(_delta):
	if !can_move:
		return
	var dir = move_dirs[randi() % 4]
	if dir == -last_dir:
		return
	last_dir = dir
	var space = get_world().direct_space_state
	var collision = space.intersect_ray(mesh.global_transform.origin + dir * 2,
			mesh.global_transform.origin + dir * 2 + Vector3.DOWN * 2,
			[self])
	if !collision:
		return
	roll(dir)
