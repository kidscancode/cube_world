extends CanvasLayer

signal finished

func wipe_in():
	$AnimationPlayer.play("wipe_in")

func wipe_out():
	$AnimationPlayer.play("wipe_out")


func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("finished")
