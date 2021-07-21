extends Spatial

export (Vector3) var movement = Vector3(0, 0, -6)
export var cycle_time = 4.0

var dir = 1
var stopped = false

onready var tween = $Tween
onready var body = $StaticBody
onready var rtrans = $StaticBody/RemoteTransform

func _ready():
	move()
	
func move():
	if dir == 1:
		tween.interpolate_property(body, "transform:origin",
			Vector3.ZERO, movement, cycle_time,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	else:
		tween.interpolate_property(body, "transform:origin",
			movement, Vector3.ZERO, cycle_time,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

func grab(path):
	rtrans.remote_path = path
	
func release():
	rtrans.remote_path = ""

func _on_Tween_tween_all_completed():
	stopped = true
	dir = -dir
	yield(get_tree().create_timer(1), "timeout")
	stopped = false
	move()
