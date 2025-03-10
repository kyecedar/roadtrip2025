extends CharacterBody3D

var state_machine

var max_speed = 50
var min_speed = 0
var gravity = 1
@onready var front = $front
@onready var raycast = $RayCast3D
@onready var nav = $NavigationAgent3D
func update_target_location(target_location):
	nav.set_target_position(target_location)
	self.look_at(target_location)
func _physics_process(delta):

	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y -= 1
	var current_location = global_transform.origin
	var next_location = nav.get_next_path_position()
	var new_velocity = (next_location-current_location).normalized() * max_speed
	velocity = velocity.move_toward(new_velocity,0.25)
	velocity.clampf(min_speed,max_speed)
	print(new_velocity)
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		pass
		#	current speed *.85 for 5 seconds
		#cum()
	if body.is_in_group("enemy"):
		pass
		# current speed * 1.2 for 1 second
		#stop cumming()
