tool
extends Area

export var length = 8.0 setget set_length
export (AudioStream) var on_sound
export (AudioStream) var off_sound

var on = true

onready var beam = $LaserBeam
onready var collision = $CollisionShape

func set_length(value):
	length = value
	beam.mesh.height = length
	beam.transform.origin.x = length / 2
	collision.shape.height = length
	collision.transform.origin.x = length/2

func open():
	on = false
	beam.hide()
	collision.set_deferred("disabled", true)
	if off_sound:
		AudioManager.play(off_sound, 4)
	
func close():
	on = true
	beam.show()
	collision.set_deferred("disabled", false)
	if on_sound:
		AudioManager.play(on_sound, 4)

func _on_LaserBeam_area_entered(area):
	if on:
		area.die()
