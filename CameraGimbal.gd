extends Spatial

export (NodePath) var target_path
onready var target = get_node(target_path)

export (float, 0.0, 2.0) var rotation_speed = PI/2

# mouse properties

export (float) var distance = 8
export (bool) var mouse_control = true
export (float, 0.001, 0.1) var mouse_sensitivity = 0.003
export (bool) var invert_y = false
export (bool) var invert_x = false

# zoom settings

export (float) var max_zoom = 3.0
export (float) var min_zoom = 0.4
export (float, 0.05, 1.0) var zoom_speed = 0.09

var zoom = 3

func _ready():
	$InnerGimbal/Camera.transform.origin.z = distance

func _unhandled_input(event):
#	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
#		return
	if event.is_action_pressed("cam_zoom_in"):
		zoom -= zoom_speed
	if event.is_action_pressed("cam_zoom_out"):
		zoom += zoom_speed
	zoom = clamp(zoom, min_zoom, max_zoom)
	if mouse_control and event is InputEventMouseMotion and Input.is_action_pressed("mouse_left_click"):
		if event.relative.x != 0:
			var dir = 1 if invert_x else -1
			rotate_object_local(Vector3.UP, dir * event.relative.x * mouse_sensitivity)
		if event.relative.y != 0:
			var dir = 1 if invert_y else -1
			var y_rotation = clamp(event.relative.y, -30, 30)
			$InnerGimbal.rotate_object_local(Vector3.RIGHT, dir * y_rotation * mouse_sensitivity)

func get_input_keyboard(delta):
	# Rotate outer gimbal around y axis

	var y_rotation = 0
	if Input.is_action_pressed("cam_right"):
		y_rotation += 1
	if Input.is_action_pressed("cam_left"):
		y_rotation += -1
	rotate_object_local(Vector3.UP, y_rotation * rotation_speed * delta)
	# Rotate inner gimbal around local x axis

	var x_rotation = 0
	if Input.is_action_pressed("cam_up"):
		x_rotation += -1
	if Input.is_action_pressed("cam_down"):
		x_rotation += 1
	x_rotation = -x_rotation if invert_y else x_rotation
	$InnerGimbal.rotate_object_local(Vector3.RIGHT, x_rotation * rotation_speed * delta)

func _process(delta):
	if !mouse_control:
		get_input_keyboard(delta)
	$InnerGimbal.rotation.x = clamp($InnerGimbal.rotation.x, -1.4, -0.01)
	scale = lerp(scale, Vector3.ONE * zoom, zoom_speed)
	if target:
		global_transform.origin = lerp(global_transform.origin, target.global_transform.origin, 5 * delta)
