extends CanvasLayer

func wipe_in():
	$AnimationPlayer.play("wipe_in")
	return $AnimationPlayer
	
func wipe_out():
	$AnimationPlayer.play("wipe_out")
	return $AnimationPlayer
