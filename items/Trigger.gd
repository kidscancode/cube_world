#tool
extends Area
class_name Trigger

enum types{GOAL, TELEPORTER, PRESSURE_PLATE}
export (types) var type # setget update_type

export (NodePath) var target_path
var target

var colors = [Color(.08, .60, .41), Color(.86, .14, .9), Color(1, 1, 1)]
var mats = [
	preload("res://items/materials/goal.tres"),
	preload("res://items/materials/teleporter.tres"),
	preload("res://items/materials/door_plate.tres")
]

func _ready():
	if target_path:
		target = get_node(target_path)
	$MeshInstance.material_override = mats[type]

func update_type(_type):
	type = _type
#	if Engine.editor_hint:
#		print("changed")
	yield(self, "tree_entered")
	
func _on_Trigger_area_entered(area):
	match type:
		types.GOAL:
			print("Win!")
		types.TELEPORTER:
			if !target:
				return
			target.disable()
			area.global_transform.origin = target.global_transform.origin
		types.PRESSURE_PLATE:
			if !target:
				return
			target.open()


func _on_Trigger_area_exited(_area):
	if type == types.PRESSURE_PLATE:
		if !target:
			return
		target.close()


func disable():
	monitoring = false
	yield(get_tree().create_timer(0.2), "timeout")
	monitoring = true


func _on_Trigger_body_entered(_body):
	if type == types.PRESSURE_PLATE:
		if !target:
			return
		target.open()


func _on_Trigger_body_exited(_body):
	if type == types.PRESSURE_PLATE:
		if !target:
			return
		target.close()
