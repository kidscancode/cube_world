extends Area

export (NodePath) var target_path
onready var target = get_node(target_path)


func disable():
	monitoring = false
	yield(get_tree().create_timer(0.2), "timeout")
	monitoring = true
	
func _on_Teleporter_area_entered(area):
	if !target:
		return
	target.disable()
	area.global_transform.origin = target.global_transform.origin
