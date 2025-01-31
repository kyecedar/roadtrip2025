extends VehicleBody3D


# TODO:
# - fix camera reverse funk.


# https://www.youtube.com/watch?v=5m7nBj98rx4

#region // Variables.

@export var MAX_STEER        : float = 0.8
@export var WHEEL_TURN_SPEED : float = 2.5
@export var ENGINE_POWER     : float = 250.0

@export var CAMERA_FOLLOW_AMOUNT : float = 20.0
@export var CAMERA_INTERPOLATE_AMOUNT : float = 5.0

var look_at : Vector3 = Vector3.ZERO

#endregion Variables. ////////////////////



#region // Functions.

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	look_at = global_position

func _physics_process(delta: float) -> void:
	steering = move_toward(steering, Input.get_axis("turn_right", "turn_left") * MAX_STEER, delta * WHEEL_TURN_SPEED)
	engine_force = Input.get_axis("go_backwards", "go_forwards") * ENGINE_POWER
	
	process_camera(delta)


func process_camera(delta: float) -> void:
	%CameraPivot.global_position = %CameraPivot.global_position.lerp(global_position, delta * CAMERA_FOLLOW_AMOUNT)
	%CameraPivot.transform = %CameraPivot.transform.interpolate_with(transform, delta * CAMERA_INTERPOLATE_AMOUNT)
	
	# look in direction car is turning in.
	look_at = look_at.lerp(global_position + linear_velocity, delta * CAMERA_INTERPOLATE_AMOUNT)
	%ForwardCamera.look_at(look_at)
	%BackwardCamera.look_at(look_at)
	
	handle_camera_switch()

## If reversing, switch to use BackwardCamera.
func handle_camera_switch() -> void:
	if Input.is_action_pressed("go_backwards"):
		%BackwardCamera.current = true
	elif Input.is_action_pressed("go_forwards") || linear_velocity.dot(transform.basis.z) > 0:
		%ForwardCamera.current = true
	
	#if linear_velocity.dot(transform.basis.z) > 0:
		#%ForwardCamera.current = true
	#elif Input.is_action_pressed("go_backwards"):
		#%BackwardCamera.current = true

#endregion Functions. ////////////////////
