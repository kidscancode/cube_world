extends CubeBase

export (NodePath) var camera_path
onready var camera = get_node(camera_path)
var mat = preload("res://effects/cube_green_01_dissolve.tres")
var mesh_material

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
		
	if Input.is_action_pressed("right"):
		roll(forward.rotated(Vector3.UP, -PI/2))
	if Input.is_action_pressed("left"):
		roll(forward.rotated(Vector3.UP, PI/2))
	if Input.is_action_pressed("up"):
		roll(forward)
	if Input.is_action_pressed("down"):
		roll(-forward)

func after_roll():
	fall()

func appear():
	tween.interpolate_property(mesh_material, "shader_param/offset",
		1, 0, .8, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	
func disappear():
	tween.interpolate_property(mesh_material, "shader_param/offset",
		0, 1, .8, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

func teleport(pos):
	disappear()
	yield(tween, "tween_all_completed")
	global_transform.origin = pos
	appear()
	yield(tween, "tween_all_completed")

