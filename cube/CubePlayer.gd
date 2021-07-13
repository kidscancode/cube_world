extends CubeBase

func _ready():
	connect("roll_complete", self, "after_roll")

func _physics_process(_delta):
	if Input.is_action_pressed("right"):
		roll(Vector3.RIGHT)
	if Input.is_action_pressed("left"):
		roll(Vector3.LEFT)
	if Input.is_action_pressed("up"):
		roll(Vector3.FORWARD)
	if Input.is_action_pressed("down"):
		roll(Vector3.BACK)

func after_roll():
	fall()
