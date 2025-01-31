extends VehicleBody3D


# TODO:
# add deflection off walls.
# after roads are added, add nearest-node-teleportation-upon-button-held option.


# https://www.youtube.com/watch?v=5m7nBj98rx4

#region // Variables.

@export var MAX_STEER        : float = 45.0 ## Degrees.
@export var WHEEL_TURN_SPEED : float =  1.0 ## 2.5 is really good handling, 1.5 is okay handling, 0.5 is shit handling.

@export var BODY_LEAN_HELP_RATIO : float = 25.0 ## In degrees.

@export_subgroup("Engine", "ENGINE_")

@export var ENGINE_FORWARDS_POWER  : float = 15000.0
@export var ENGINE_BACKWARDS_POWER : float = 10000.0

@export_subgroup("Camera", "CAMERA_")

@export var CAMERA_FOLLOW_AMOUNT      : float = 20.0
@export var CAMERA_INTERPOLATE_AMOUNT : float =  5.0

@export var CAMERA_LEAN_RATIO : float = 50.0 ## Is divided by local x linear_velocity.

@export var CAMERA_FORWARD_MIN  : float = 5.0
@export var CAMERA_BACKWARD_MIN : float = -6.0

@export var CAMERA_MAX_ROLL_ROTATION : float = 30.0 ## In degrees.

var forward_look_at : Vector3 = Vector3.ZERO
var backward_look_at : Vector3 = Vector3.ZERO

#endregion Variables. ////////////////////



#region // Functions.

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	forward_look_at = global_position
	backward_look_at = global_position

func _physics_process(delta: float) -> void:
	steering = move_toward(steering, Input.get_axis("turn_right", "turn_left") * deg_to_rad(MAX_STEER), delta * WHEEL_TURN_SPEED)
	var forwards_power : float = Input.get_action_strength("go_forwards") * ENGINE_FORWARDS_POWER
	var backwards_power : float = -Input.get_action_strength("go_backwards") * ENGINE_BACKWARDS_POWER
	engine_force = forwards_power + backwards_power
	
	process_body(delta)
	process_camera(delta)


func process_body(delta: float) -> void:
	rotation.z = move_toward(rotation.z, clamp(rotation.z, -deg_to_rad(BODY_LEAN_HELP_RATIO), deg_to_rad(BODY_LEAN_HELP_RATIO)), delta * 1.0)
	#rotation.z = move_toward(rotation.z, 0.0, delta * 50.0)
	#rotation.x = move_toward(rotation.x, 0.0, delta * 50.0)
	pass

func process_camera(delta: float) -> void:
	%CameraPivot.global_position = %CameraPivot.global_position.lerp(global_position, delta * CAMERA_FOLLOW_AMOUNT)
	%CameraPivot.transform = %CameraPivot.transform.interpolate_with(transform, delta * CAMERA_INTERPOLATE_AMOUNT)
	
	var z_dot : float = linear_velocity.dot(transform.basis.z)
	var x_dot : float = linear_velocity.dot(transform.basis.x)
	
	# look in direction car is turning in.
	# clamp value for forward to only be facing forward, opposite for back.
	forward_look_at = forward_look_at.lerp(global_position + Vector3(max(z_dot, CAMERA_FORWARD_MIN), 0.0, max(z_dot, CAMERA_FORWARD_MIN)) * transform.basis.z, delta * CAMERA_INTERPOLATE_AMOUNT)
	backward_look_at = backward_look_at.lerp(global_position + Vector3(min(z_dot, CAMERA_BACKWARD_MIN), 0.0, min(z_dot, CAMERA_BACKWARD_MIN)) * transform.basis.z, delta * CAMERA_INTERPOLATE_AMOUNT)
	
	%ForwardCamera.look_at(forward_look_at)
	%BackwardCamera.look_at(backward_look_at)
	
	# lean camera into turns.
	%ForwardCamera.rotate_z(x_dot / 50.0)
	%BackwardCamera.rotate_z(-x_dot / 50.0)
	
	%ForwardCamera.rotation.z = clamp(%ForwardCamera.rotation.z, -deg_to_rad(CAMERA_MAX_ROLL_ROTATION), deg_to_rad(CAMERA_MAX_ROLL_ROTATION))
	
	#print(x_dot)
	
	handle_camera_switch()

## If reversing, switch to use BackwardCamera.
func handle_camera_switch() -> void:
	if Input.is_action_pressed("go_backwards"):
		%BackwardCamera.current = true
	elif Input.is_action_pressed("go_forwards") || linear_velocity.dot(transform.basis.z) > 0:
		%ForwardCamera.current = true

#endregion Functions. ////////////////////
