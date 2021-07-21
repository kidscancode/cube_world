extends CanvasLayer

signal finished

func wipe_in():
	$AnimationPlayer.play("square_wipe_out")

func wipe_out():
	$AnimationPlayer.play("square_wipe_in")


func _on_AnimationPlayer_animation_finished(_anim_name):
	emit_signal("finished")
