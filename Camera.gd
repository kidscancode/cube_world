extends Camera

export var lerp_speed = 4

export (NodePath) var target_path = null
export (Vector3) var offset = Vector3.ZERO

onready var target = get_node(target_path).get_node("Pivot/MeshInstance")

func _physics_process(delta):
	if !target:
		return
	var target_pos = target.global_transform.origin + offset
	global_transform.origin = lerp(global_transform.origin, 
			target_pos, lerp_speed * delta)
#	global_transform = global_transform.interpolate_with(global_transform.looking_at(target.global_transform.origin, Vector3.UP),
#			lerp_speed/2 * delta)
