extends Spatial
onready var tween = $Tween

var mat = preload("res://effects/cube_green_01_dissolve.tres")
#onready var mat = $Cube001.mesh.surface_get_material(0)
var mesh_material

func _ready():
	$Cube001.mesh.surface_set_material(0, mat)
	mesh_material = $Cube001.mesh.surface_get_material(0)
#	print(mesh_material.get_shader_param("offset"))
	yield(get_tree().create_timer(1), "timeout")
	_disappear()
	yield(tween, "tween_all_completed")
	$Cube001.translate(Vector3(2, 0, 0))
	_appear()
	
func _on_Timer_timeout():
	pass # Replace with function body.

func _appear():
	tween.interpolate_property(mesh_material, "shader_param/offset",
		1, 0, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	
func _disappear():
	tween.interpolate_property(mesh_material, "shader_param/offset",
		0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
