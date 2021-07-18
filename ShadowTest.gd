extends Spatial

func _input(event):
	if event.is_action_pressed("ui_select"):
		var f = $MeshInstance.global_transform.basis.y
		print(f)
		print($MeshInstance2.global_transform.basis.y)
		print(f.slide($MeshInstance2.global_transform.basis.y).normalized())
		


func _on_ShadowTest_ready():
	print("scene ready")
