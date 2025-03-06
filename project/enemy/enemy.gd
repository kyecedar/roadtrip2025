extends CharacterBody3D

var state_machine

var SPEED = 100000
var gravity = 1
@onready var raycast = $RayCast3D
@onready var nav = $NavigationAgent3D
func update_target_location(target_location):
	nav.set_target_position(target_location)
func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y -= 1
	var current_location = global_transform.origin
	var next_location = nav.get_next_path_position()
	var new_velocity = (next_location-current_location).normalized() * SPEED
	velocity = velocity.move_toward(new_velocity,0.25)
	move_and_slide()
