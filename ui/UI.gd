extends Node

export (AudioStream) var music

var game_scene = null
var num_levels = 0

onready var current_menu = $MenuLayer/Title
onready var overlay = $OverlayLayer
onready var message = $MessageLayer


func _ready():
	register_buttons()
	get_levels()
	$MenuLayer/LevelSelect.init_grids()
#	go_to_title()

func get_levels():
	var n = 0
	var d = Directory.new()
	if d.open("res://levels") == OK:
		print("scanning for levels...")
		d.list_dir_begin(true, true)
		var file_name = d.get_next()
		while file_name != "":
			if file_name.begins_with("Level") and filename.get_extension() == "tscn":
				n += 1
			file_name = d.get_next()
	print(n, " levels found")
	num_levels = n

func register_buttons():
	var buttons = get_tree().get_nodes_in_group("menu_buttons")
	for button in buttons:
		button.connect("pressed", self, "_on_button_pressed", [button])
	$MenuLayer/LevelSelect.connect("level_selected", self, "_on_level_selected")

func _on_level_selected(level):
	UI.overlay.wipe_in()
	yield(UI.overlay, "finished")
	$MenuLayer/LevelSelect.end()
	game_scene.start_game(level)
	
	
func _on_button_pressed(button):
	match button.name:
		"PlayButton":
			$MenuLayer/Title.end()
			$MenuLayer/LevelSelect.start()
			current_menu = $MenuLayer/LevelSelect
#			yield($MenuLayer/Title, "menu_ready")
#			UI.overlay.wipe_in()
#			yield(UI.overlay, "finished")
#			$MenuLayer/Title.end()
#			game_scene.start_game()
		"SettingsButton":
			pass
		"CloseButton":
			$MenuLayer/Title.start()
			current_menu.end()
			current_menu = $MenuLayer/Title

func go_to_title():
	$MenuLayer/Title.start()
