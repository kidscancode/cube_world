extends CubeBase

export (NodePath) var camera_path
onready var camera = get_node(camera_path)
var mat = preload("res://effects/cube_green_01_dissolve.tres")
var mesh_material
export (AudioStream) var appear_sound
export (AudioStream) var disappear_sound

func _ready():
	mesh = $Pivot/cube_test_green_04
	$Pivot/cube_test_green_04/Cube001.mesh.surface_set_material(0, mat)
	mesh_material = $Pivot/cube_test_green_04/Cube001.mesh.surface_get_material(0)
	connect("roll_complete", self, "after_roll")

func _physics_process(_delta):
	if !can_move:
		return
	var forward = Vector3.FORWARD
	if camera:
		forward = Vector3.ZERO
		var cam_forward = -camera.transform.basis.z.normalized()
		var cam_axis = cam_forward.abs().max_axis()
		forward[cam_axis] = sign(cam_forward[cam_axis])
		
	if Input.is_action_pressed("up"):
		roll(forward)
	if Input.is_action_pressed("down"):
		roll(-forward)
	if Input.is_action_pressed("right"):
		roll(forward.cross(Vector3.UP))
	if Input.is_action_pressed("left"):
		roll(-forward.cross(Vector3.UP))

func after_roll():
	fall()

func appear():
	tween.interpolate_property(mesh_material, "shader_param/offset",
		1, 0, .8, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	if appear_sound:
		AudioManager.play(appear_sound, 10)
	
func disappear():
	tween.interpolate_property(mesh_material, "shader_param/offset",
		0, 1, .8, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	if disappear_sound:
		AudioManager.play(disappear_sound, 10)

func teleport(pos):
	disappear()
	yield(tween, "tween_all_completed")
	global_transform.origin = pos
	appear()
	yield(tween, "tween_all_completed")

func die():
	DebugOverlay.stats.clear_properties()
	var t = pow(2 * 15 / 15, 0.5)
	tween.interpolate_property(self, "transform:origin", null,
			transform.origin + Vector3.DOWN * 15, t, Tween.TRANS_EXPO, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_all_completed")
	emit_signal("died")
