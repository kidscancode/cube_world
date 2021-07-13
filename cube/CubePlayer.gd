extends CubeBase

export (NodePath) var camera_path
onready var camera = get_node(camera_path)

func _ready():
	connect("roll_complete", self, "after_roll")

func _physics_process(_delta):
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
