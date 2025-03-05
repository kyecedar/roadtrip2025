extends VehicleBody3D


# TODO:
# add deflection off walls.
# after roads are added, add nearest-node-teleportation-upon-button-held option.


# https://www.youtube.com/watch?v=5m7nBj98rx4

#region // Variables.

var forward_look_at : Vector3 = Vector3.ZERO
var backward_look_at : Vector3 = Vector3.ZERO

var miles_per_hour : float = 0.0

@onready var back_wheel_right = $RearRight
@onready var back_wheel_left = $RearLeft
@onready var speedometer = $BackBodyMesh/speedometer
#endregion Variables. ////////////////////



#region // Functions.

func _ready() -> void:
	forward_look_at = global_position
	backward_look_at = global_position

func _physics_process(delta: float) -> void:
	process_go_go(delta)
	process_body(delta)
	process_camera(delta)
	speedometer.text = str(int (miles_per_hour))
#	if steering > 10:
#		Drive.wheels.traction * .10
func process_go_go(delta: float) -> void:
	steering = move_toward(steering, Input.get_axis("turn_right", "turn_left") * deg_to_rad(Drive.PLAYER_MAX_STEER), delta * Drive.PLAYER_WHEEL_TURN_SPEED)
	var forwards_power : float = Input.get_action_strength("go_forwards") * Drive.PLAYER_ENGINE_FORWARDS_POWER
	var backwards_power : float = -Input.get_action_strength("go_backwards") * Drive.PLAYER_ENGINE_BACKWARDS_POWER
	
	# enforce max speed by cutting engine power if it goes above max speed.
	if miles_per_hour <= Drive.PLAYER_MAX_SPEED:
		engine_force = forwards_power + backwards_power
	else:
		engine_force = 0.0

func _input(event):
	if event.is_action_pressed("drift"):
		back_wheel_right.wheel_friction_slip=0.3
		back_wheel_left.wheel_friction_slip=0.3
	else:
		back_wheel_right.wheel_friction_slip=0.8
		back_wheel_left.wheel_friction_slip=0.8
func process_body(delta: float) -> void:
	# auto upright.
	rotation.z = move_toward(rotation.z, clamp(rotation.z, -deg_to_rad(Drive.PLAYER_BODY_LEAN_HELP), deg_to_rad(Drive.PLAYER_BODY_LEAN_HELP)), delta * 1.0)


func process_camera(delta: float) -> void:
	%CameraPivot.global_position = %CameraPivot.global_position.lerp(global_position, delta * Drive.PLAYER_CAMERA_FOLLOW_AMOUNT)
	%CameraPivot.transform = %CameraPivot.transform.interpolate_with(transform, delta * Drive.PLAYER_CAMERA_INTERPOLATE_AMOUNT)
	
	var z_dot : float = linear_velocity.dot(transform.basis.z)
	var x_dot : float = linear_velocity.dot(transform.basis.x)
	
	# convert metres per second to miles per hour per eagle per football field.
	miles_per_hour = abs(z_dot) * 2.236936
	
	# look in direction car is turning in.
	# clamp value for forward to only be facing forward, opposite for back.
	forward_look_at = forward_look_at.lerp(global_position + Vector3(max(z_dot, Drive.PLAYER_CAMERA_FORWARD_MIN), 0.0, max(z_dot, Drive.PLAYER_CAMERA_FORWARD_MIN)) * transform.basis.z, delta * Drive.PLAYER_CAMERA_INTERPOLATE_AMOUNT)
	backward_look_at = backward_look_at.lerp(global_position + Vector3(min(z_dot, Drive.PLAYER_CAMERA_BACKWARD_MIN), 0.0, min(z_dot, Drive.PLAYER_CAMERA_BACKWARD_MIN)) * transform.basis.z, delta * Drive.PLAYER_CAMERA_INTERPOLATE_AMOUNT)
	
	%ForwardCamera.look_at(forward_look_at)
	%BackwardCamera.look_at(backward_look_at)
	
	# lean camera into turns.
	if Drive.PLAYER_CAMERA_LEAN_RATIO:
		%ForwardCamera.rotate_z(x_dot / Drive.PLAYER_CAMERA_LEAN_RATIO)
		%BackwardCamera.rotate_z(-x_dot / Drive.PLAYER_CAMERA_LEAN_RATIO)
	
	%ForwardCamera.rotation.z = clamp(%ForwardCamera.rotation.z, -deg_to_rad(Drive.PLAYER_CAMERA_MAX_ROLL_ROTATION), deg_to_rad(Drive.PLAYER_CAMERA_MAX_ROLL_ROTATION))
	
	handle_camera_switch()

## If reversing, switch to use BackwardCamera.
func handle_camera_switch() -> void:
	if Input.is_action_pressed("go_backwards"):
		%BackwardCamera.current = true
	elif Input.is_action_pressed("go_forwards") || linear_velocity.dot(transform.basis.z) > 0:
		%ForwardCamera.current = true

#endregion Functions. ////////////////////
