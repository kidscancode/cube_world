tool
extends Spatial

export (String, MULTILINE) var note setget update_text

onready var label = $Viewport/Label

func update_text(text):
	if not is_inside_tree():
		yield(self, "ready")
	note = text
	label.text = note

func _ready():
	label.text = note
