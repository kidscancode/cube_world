extends Node2D

var rot_speed = 3

func _process(delta):
	var input = Input.get_action_strength("stick_right") - Input.get_action_strength("stick_left")
	$Sprite.rotation += input * rot_speed * delta
