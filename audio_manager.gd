extends Node

var num_players = 16
var bus = "master"
var available = []  # The available players.
var queue = []  # The queue of sounds to play.


func _ready():
	# Create the pool of AudioStreamPlayer nodes.
	for i in num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available.append(p)
		p.connect("finished", self, "_on_stream_finished", [p])
		p.bus = bus


func _on_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	available.append(stream)


func play(sound_path, vol=0.0):
	queue.append([sound_path, vol])
	if available.empty():
		print("full")


func _process(_delta):
	# Play a queued sound if any players are available.
	if not queue.empty() and not available.empty():
		var next = queue.pop_front()
		available[0].stream = next[0]
		available[0].volume_db = next[1]
		available[0].play()
		available.pop_front()
