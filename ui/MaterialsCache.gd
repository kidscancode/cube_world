extends Spatial

# Autoload?
# First, try adding just to Level 1, then see if it persists for later levels.

var mats = [
	preload("res://items/materials/goal.tres"),
	preload("res://items/materials/teleporter.tres"),
	preload("res://items/materials/door_plate.tres")
]

func _ready():
	for mat in mats:
		var mesh = MeshInstance.new()
		mesh.mesh = QuadMesh.new()
		mesh.material_override = mat
		add_child(mesh)
		
