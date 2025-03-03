@tool
extends Node



# TODO:
# - better mouse capture shit.



#region // Signals.

signal game_paused
signal game_unpaused

signal window_size_change(size: Vector2i)
signal window_focus
signal window_unfocus

#endregion Signals. ////////////////////



#region // Variables.

#region // player.
var PLAYER_MAX_STEER        : float = 45.0 ## Degrees.
var PLAYER_WHEEL_TURN_SPEED : float =  1.0 ## 2.5 is really good handling, 1.5 is okay handling, 0.5 is shit handling.

var PLAYER_BODY_LEAN_HELP : float = 25.0 ## In degrees.

var PLAYER_ENGINE_FORWARDS_POWER  : float = 15000.0
var PLAYER_ENGINE_BACKWARDS_POWER : float = 10000.0

var PLAYER_CAMERA_FOLLOW_AMOUNT      : float = 20.0
var PLAYER_CAMERA_INTERPOLATE_AMOUNT : float =  5.0

var PLAYER_CAMERA_LEAN_RATIO : float = 50.0 ## Is divided by local x linear_velocity.

var PLAYER_CAMERA_FORWARD_MIN  : float = 5.0
var PLAYER_CAMERA_BACKWARD_MIN : float = -6.0

var PLAYER_CAMERA_MAX_ROLL_ROTATION : float = 30.0 ## In degrees.

var PLAYER_MAX_SPEED : float = 80.0 ## Miles the per hour per eagle per fooball field per AR-15 magazines.
#endregion player.


#region // input.
var mouse_captured : bool = true : set = _set_mouse_captured
#endregion input.


#region // pause.
var paused : bool :
	set(value):
		if value:
			pause() # these functions set _is_paused.
			return
		unpause()
	get():
		return _is_paused

var _is_paused : bool = false
#endregion pause.

#endregion Variables. ////////////////////



#region // Functions.

func _ready() -> void:
	print_rich("\n[wave amp=80.0 freq=1.0 connected=0]🚗 ROADTRIP2025 v" + ProjectSettings.get_setting("application/config/version") + "[/wave]\n\n")
	
	if Engine.is_editor_hint():
		set_process_unhandled_input(false)
		set_process(false)
		return
	
	#mouse_captured = true

	# update paused, calls setters.
	paused = paused
	
	get_tree().get_root().size_changed.connect(_on_window_size_changed)


#region // input.
func _set_mouse_captured(value: bool) -> void:
	mouse_captured = value
	
	Input.mouse_mode = \
		Input.MOUSE_MODE_CAPTURED if value \
		else Input.MOUSE_MODE_VISIBLE
	
#endregion input.


#region // pause.
func toggle_pause() -> void:
	paused = !paused

func pause() -> void:
	_is_paused = true
	game_paused.emit()

func unpause() -> void:
	_is_paused = false
	game_unpaused.emit()
#endregion pause.


#region // window.
func _on_window_size_changed() -> void:
	pass
#endregion window.

#endregion Functions. ////////////////////
