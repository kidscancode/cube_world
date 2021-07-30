tool
extends Spatial

export (Vector3) var movement = Vector3(0, 0, -6) setget set_movement
export var cycle_time = 4.0
export var wait_time = 1.0

var dir = 1
var stopped = false

onready var tween = $Tween
onready var timer = $Timer
onready var body = $StaticBody
onready var rtrans = $StaticBody/RemoteTransform

func set_movement(value):
	movement = value
	if Engine.is_editor_hint():
		$EndPoint.show()
		$EndPoint.transform.origin = movement + Vector3(0, 0.5, 0)
	
func _ready():
	if not Engine.is_editor_hint():
		$EndPoint.hide()
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
#	get_tree().create_timer(wait_time).connect("timeout", self, "_on_Timer_timeout")
	timer.start(wait_time)

func _on_Timer_timeout():
	dir = -dir
	stopped = false
	move()
