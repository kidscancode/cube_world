extends Node

onready var overlay = $OverlayLayer
onready var message = $MessageLayer

var game_scene = null

func _ready():
	register_buttons()
#	go_to_title()

	
func register_buttons():
	var buttons = get_tree().get_nodes_in_group("menu_buttons")
	for button in buttons:
		button.connect("pressed", self, "_on_button_pressed", [button])

func _on_button_pressed(button):
	match button.name:
		"PlayButton":
#			yield($MenuLayer/Title, "menu_ready")
			UI.overlay.wipe_in()
			yield(UI.overlay, "finished")
			$MenuLayer/Title.end()
			game_scene.start_game()
		"SettingsButton":
			pass

func go_to_title():
	$MenuLayer/Title.start()
