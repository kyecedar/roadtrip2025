extends VehicleController



# TODO :
# - CREATE ANTI-TIP measures
# - add exposed crucial variables.



@export var camera : Camera3D
@export var camera_focal : Node3D

## In meters. The amount the camera goes in steering direction.w
@export var camera_turn_towards_distance : float = 2.0

# https://byteatatime.dev/posts/easings/
## Easing function the camera uses while turning.
@export var camera_turn_towards_ease_function : float = -2.0

var camera_turn_lean : float = 0.0

@export var base_fov : float = 75.0
@export var base_speed_fov_adjustment : float = 30.0

## KM/H. Min speed where [member speed_fov_adjustment] starts to be applied.
@export var min_speed_for_fov_adjustment : float = 40.0

## KM/H. Max speed where [member speed_fov_adjustment] is fully applied.
@export var max_speed_for_fov_adjustment : float = 90.0

@export var fov_adjustment_ease_function : float = -1.0

var speed_fov_adjustment : float = 0.0


func _process(delta: float) -> void:
	process_camera_focal(delta)
	process_camera_fov(delta)


func process_camera_focal(delta: float) -> void:
	camera_focal.rotation = camera.rotation
	
	camera_turn_lean = move_toward(camera_turn_lean, (-vehicle_node.steering_input + 1.0) / 2.0, delta)
	camera_focal.position.x = (ease(camera_turn_lean, camera_turn_towards_ease_function) - 0.5)

func process_camera_fov(delta: float) -> void:
	var fov_adjustment_speed : float = clampf(vehicle_node.speed * 3.6 - min_speed_for_fov_adjustment, 0.0, max_speed_for_fov_adjustment - min_speed_for_fov_adjustment)
	var fov_adjustment_amount : float = max(fov_adjustment_speed / (max_speed_for_fov_adjustment - min_speed_for_fov_adjustment), 0)
	print(fov_adjustment_speed)
	
	speed_fov_adjustment = move_toward(speed_fov_adjustment, fov_adjustment_amount, delta)
	
	camera.fov = base_fov + (ease(speed_fov_adjustment, fov_adjustment_ease_function) * base_speed_fov_adjustment)
