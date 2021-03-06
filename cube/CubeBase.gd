extends Area
class_name CubeBase

signal roll_complete
signal died

export var size = 2
export var speed = 4.0
export var fall_distance = 10.0
export (Texture) var override_texture
#export (String, FILE, "*.wav") var move_sound
export (AudioStream) var move_sound

var can_move = true
var platform = null

onready var pivot = $Pivot
onready var mesh = $Pivot/MeshInstance
onready var tween = $Tween

func _ready():
	pivot.set_disable_scale(true)
#	tween.connect("tween_step", self, "_on_Tween_tween_step")
	mesh.mesh = mesh.mesh.duplicate()
	if override_texture:
		mesh.mesh.material = mesh.mesh.material.duplicate()
		mesh.mesh.material.albedo_texture = override_texture

func roll(dir):
	if tween.is_active():
		return
	if platform:
		if platform.stopped:
			platform.release()
			platform = null
		else:
			return

	if check_collision(dir):
		return
	
	can_move = false
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
		AudioManager.play(move_sound, 8)

	## Finalize movement and reverse the offset
	transform.origin += dir * 2
	var b = mesh.global_transform.basis
	pivot.transform = Transform.IDENTITY
	mesh.transform.origin = Vector3(0, 1, 0)
	mesh.global_transform.basis = b
#	transform.origin = transform.origin.round()
	
	# TODO: clean up.
	# Wait for area_entered to fire so movement will stop on triggers
	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")
	can_move = true

	emit_signal("roll_complete")


func check_collision(dir):
	# cast a ray before moving to check for obstacles
	var space = get_world().direct_space_state
	var collision = space.intersect_ray(mesh.global_transform.origin,
			mesh.global_transform.origin + dir * 2.5, [self],
			collision_mask, true, true)
	if collision:
		if collision.collider.has_method("push") and collision.collider.pushable:
			return not collision.collider.push(dir)
		return true
	return false
		
func check_cliff(dir):
	var space = get_world().direct_space_state
	var coll = space.intersect_ray(transform.origin + dir * size + Vector3.UP,
	(transform.origin + dir * size) + Vector3.DOWN * 2,
	[self], 2147483647, true, true)
	if coll:
		return true
	return false

func fall():
	# Cast ray down after move
	var space = get_world().direct_space_state
	var collision = space.intersect_ray(mesh.global_transform.origin,
			mesh.global_transform.origin + Vector3.DOWN * fall_distance,
			[self])
	if !collision:
		die()
	elif collision["collider"] is Block and collision["collider"].falling:
		die()
	elif collision["collider"].is_in_group("platforms"):
		platform = collision["collider"].get_parent()
		platform.grab(get_path())
	else:
		# What's under us?
		var pos = collision["position"]
		var dist = transform.origin.distance_to(pos)
		if dist > 1:
			# Calculate fall time (looks better)
			var t = pow(2 * dist / 15, 0.5)
			tween.interpolate_property(self, "transform:origin", null,
					pos, t, Tween.TRANS_EXPO, Tween.EASE_IN)
			tween.start()
			yield(tween, "tween_all_completed")
#		var ground = collision["collider"]
#		if ground.name == "GridMap":
#			var c = ground.world_to_map(transform.origin + Vector3.DOWN)
#			ground.set_cell_item(c.x, c.y, c.z, 1)

func die():
	pass
