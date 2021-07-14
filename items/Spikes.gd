extends Area

var up = true

onready var spikes = $spikes
onready var tween = $Tween

func _on_Timer_timeout():
	up = not up
#	spikes.visible = up
	if up:
		tween.interpolate_property(spikes, "transform:origin:y", -0.32,
		-0.005, 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	else:
		tween.interpolate_property(spikes, "transform:origin:y", -0.005,
		-0.32, 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	if up and get_overlapping_areas().size() == 1:
		get_overlapping_areas()[0].die()

func _on_Spikes_area_entered(area):
	if up:
		area.die()
