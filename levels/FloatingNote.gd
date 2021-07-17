extends Spatial

export (String, MULTILINE) var note

func _ready():
	$Viewport/Label.text = note
