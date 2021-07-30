extends MarginContainer

signal level_selected

var current_grid = 1
var num_grids = 1

var grid_width = 714  # clip size

onready var grid_box = $VBoxContainer/HBoxContainer/ClipControl/GridBox
onready var tween = $Tween

func _ready():
	num_grids = grid_box.get_child_count()
	for grid in grid_box.get_children():
		for button in grid.get_children():
			button.connect("level_selected", self, "_on_level_selected")
		
func _on_level_selected(level):
	emit_signal("level_selected", level)


func _on_BackButton_pressed():
	print("back")
	if current_grid > 1:
		current_grid -= 1
#		grid_box.rect_position.x += grid_width
		tween.interpolate_property(grid_box, "rect_position:x",
				grid_box.rect_position.x,
				grid_box.rect_position.x + grid_width,
				0.54, Tween.TRANS_BACK, Tween.EASE_OUT)
		tween.start()

func _on_NextButton_pressed():
	print("next")
	if current_grid < num_grids:
		current_grid += 1
#		grid_box.rect_position.x -= grid_width
		tween.interpolate_property(grid_box, "rect_position:x",
				grid_box.rect_position.x,
				grid_box.rect_position.x - grid_width,
				0.54, Tween.TRANS_BACK, Tween.EASE_OUT)
		tween.start()
