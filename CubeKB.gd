extends KinematicBody

export var speed = 4.0
export var fall_distance = 10.0
export (String, FILE) var move_sound

onready var pivot = $Pivot
onready var mesh = $Pivot/MeshInstance
onready var tween = $Tween

func _physics_process(_delta):
	if Input.is_action_pressed("right"):
		roll(Vector3.RIGHT)
	if Input.is_action_pressed("left"):
		roll(Vector3.LEFT)
	if Input.is_action_pressed("up"):
		roll(Vector3.FORWARD)
	if Input.is_action_pressed("down"):
		roll(Vector3.BACK)
		
func roll(dir):
	if tween.is_active():
		return
	# cast a ray before moving to check for obstacles
	var space = get_world().direct_space_state
	var collision = space.intersect_ray(mesh.global_transform.origin,
			mesh.global_transform.origin + dir * 2.5, [self])
	if collision:
		return
	
	## Offset the pivot
	pivot.translate(dir)
	mesh.global_translate(-dir)
	
	## Rotate
	var axis = dir.cross(Vector3.DOWN)
	tween.interpolate_property(pivot, "transform:basis",
			null, pivot.transform.basis.rotated(axis, PI/2),
			1/speed, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_all_completed")
	if move_sound:
		AudioManager.play(move_sound)

	## Finalize movement and reverse the offset
	transform.origin += dir * 2
	var b = mesh.global_transform.basis
	pivot.transform = Transform.IDENTITY
	mesh.transform.origin = Vector3(0, 1, 0)
	mesh.global_transform.basis = b

	# Cast ray down after move
	space = get_world().direct_space_state
	collision = space.intersect_ray(mesh.global_transform.origin,
			mesh.global_transform.origin + Vector3.DOWN * fall_distance,
			[self])
	if !collision:
		# Falling to death
		get_tree().reload_current_scene()
	else:
		# What's under us?
		var ground = collision["collider"]
		var pos = collision["position"]
		var dist = transform.origin.distance_to(pos)
		if dist > 1:
			# Calculate fall time (looks better)
			var t = pow(2 * dist / 15, 0.5)
			tween.interpolate_property(self, "transform:origin", null,
					pos, t, Tween.TRANS_EXPO, Tween.EASE_IN)
			tween.start()
			yield(tween, "tween_all_completed")
			AudioManager.play("res://assets/sounds/Click_Heavy_00.wav")
		if ground.name == "GridMap":
			var c = ground.world_to_map(transform.origin + Vector3.DOWN)
			ground.set_cell_item(c.x, c.y, c.z, 1)


func _on_Tween_tween_step(_object, _key, _elapsed, _value):
	pivot.transform = pivot.transform.orthonormalized()
#	pass
