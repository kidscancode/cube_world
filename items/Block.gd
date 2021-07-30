tool
extends StaticBody
class_name Block

export var pushable = false setget set_pushable
export (AudioStream) var slide_sound

var falling = false

onready var tween = $Tween

func set_pushable(value):
	pushable = value
	if pushable:
		$MeshInstance.material_override = load("res://items/materials/block_purple.tres")
	else:
		$MeshInstance.material_override = load("res://items/materials/block_red.tres")

func push(dir):
	# can we move there?
	var space = get_world().direct_space_state
	var collision = space.intersect_ray(global_transform.origin,
			global_transform.origin + dir * 2.5, [self],
			2147483647, true, true)
	if collision:
		return false
		
	tween.interpolate_property(self, "transform:origin", null,
			transform.origin + dir * 2, 0.25,
			Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	if slide_sound:
		AudioManager.play(slide_sound, 1)
	return true


func _on_Tween_tween_all_completed():
	if falling:
		queue_free()
	var space = get_world().direct_space_state
	var collision = space.intersect_ray(global_transform.origin,
			global_transform.origin + Vector3.DOWN * 2, [self],
			2147483647, true, true)
	if !collision:
		pushable = false
		falling = true
#		$CollisionShape.set_deferred("disabled", true)
		tween.interpolate_property(self, "transform:origin", null,
			transform.origin + Vector3.DOWN * 10, 1.5,
			Tween.TRANS_EXPO, Tween.EASE_IN)
		tween.start()
		
		
