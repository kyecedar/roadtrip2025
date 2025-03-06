extends RigidBody3D

var state_machine

const SPEED = 1000000

@onready var nav = $NavigationAgent3D

func _process(delta: float) -> void:
	var current_location = global_transform.origin
	var next_location = nav.get_next_path_position()
	set_linear_velocity((next_location-current_location)*SPEED)
	
func target_position(target):
	nav.target_position = target
	print("going")
