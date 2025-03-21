@tool
extends Node

## In degrees.
@export var max_steer : float = 45.0 :
	set(value):
		Roadtrip.PLAYER_MAX_STEER = value
	get():
		return Roadtrip.PLAYER_MAX_STEER

## 2.5 is really good handling, 1.5 is okay handling, 0.5 is shit handling.
@export var wheel_turn_speed : float = 1.0 :
	set(value):
		Roadtrip.PLAYER_WHEEL_TURN_SPEED = value
	get():
		return Roadtrip.PLAYER_WHEEL_TURN_SPEED

## In degrees.
@export var body_lean_help : float = 25.0 :
	set(value):
		Roadtrip.PLAYER_BODY_LEAN_HELP = value
	get():
		return Roadtrip.PLAYER_BODY_LEAN_HELP


@export_subgroup("Engine", "engine_")

@export var engine_forwards_power : float = 15000.0 :
	set(value):
		Roadtrip.PLAYER_ENGINE_FORWARDS_POWER = value
	get():
		return Roadtrip.PLAYER_ENGINE_FORWARDS_POWER

@export var engine_backwards_power : float = 10000.0 :
	set(value):
		Roadtrip.PLAYER_ENGINE_BACKWARDS_POWER = value
	get():
		return Roadtrip.PLAYER_ENGINE_BACKWARDS_POWER


@export_subgroup("Camera", "camera_")

@export var camera_follow_amount : float = 20.0 :
	set(value):
		Roadtrip.PLAYER_CAMERA_FOLLOW_AMOUNT = value
	get():
		return Roadtrip.PLAYER_CAMERA_FOLLOW_AMOUNT

@export var camera_interpolate_amount : float = 5.0 :
	set(value):
		Roadtrip.PLAYER_CAMERA_INTERPOLATE_AMOUNT = value
	get():
		return Roadtrip.PLAYER_CAMERA_INTERPOLATE_AMOUNT

## Is divided by local x linear velocity.
@export var camera_lean_ratio : float = 50.0 :
	set(value):
		Roadtrip.PLAYER_CAMERA_LEAN_RATIO = value
	get():
		return Roadtrip.PLAYER_CAMERA_LEAN_RATIO

@export var camera_forward_min : float = 5.0 :
	set(value):
		Roadtrip.PLAYER_CAMERA_FORWARD_MIN = value
	get():
		return Roadtrip.PLAYER_CAMERA_FORWARD_MIN

@export var camera_backward_min : float = -6.0 :
	set(value):
		Roadtrip.PLAYER_CAMERA_BACKWARD_MIN = value
	get():
		return Roadtrip.PLAYER_CAMERA_BACKWARD_MIN

## In degrees.
@export var camera_max_roll_rotation : float = 30.0 :
	set(value):
		Roadtrip.PLAYER_CAMERA_MAX_ROLL_ROTATION = value
	get():
		return Roadtrip.PLAYER_CAMERA_MAX_ROLL_ROTATION
