@tool
extends Node



# TODO:
# - better mouse capture shit.



#region // SIGNALS. ////////////////////////////////////////////////////////////

signal game_paused
signal game_unpaused

signal window_size_change(size: Vector2i)
signal window_focus
signal window_unfocus

signal inventory_updated

#endregion SIGNALS.



#region // VARIABLES. //////////////////////////////////////////////////////////

#region // player. /////
var max_torque: float = 350
var max_rpm: float = 3000
var front_weight_distribution: float = 0.5
var front_spring_length : float = 0.10
## How much the spring is compressed when the vehicle is at rest.
## This is used to calculate the approriate spring rate for the wheel.
## A value of 0 would be a fully compressed spring.(normal is 0.5)
var front_resting_ratio : float = 0.5
## Damping ratio is used to calculate the damping forces on the spring.
## A value of 1 would be critically damped. Passenger cars typically have a
## ratio around 0.3, while a race car could be as high as 0.9.
var front_damping_ratio : float = 0.3
## Bump damping multiplier applied to the damping force calulated from the
## damping ratio. A typical ratio for a passenger car is 2/3 bump damping to
## 3/2 rebound damping. Race cars typically run 3/2 bump to 2/3 rebound.
var front_bump_damp_multiplier : float = 0.67
## Rebound damping multiplier applied to the damping force calulated from the
## damping ratio. A typical ratio for a passenger car is 2/3 bump damping to
## 3/2 rebound damping. Race cars typically run 3/2 bump to 2/3 rebound.
var front_rebound_damp_multiplier : float = 1.3

## The amount of suspension travel in meters. Rear suspension typically has
## more travel than the front.
var rear_spring_length : float = 0.10
## How much the spring is compressed when the vehicle is at rest.
## This is used to calculate the approriate spring rate for the wheel.
## A value of 1 would be a fully compressed spring. With a value of 0.5 the
## suspension will rest at the center of it's length.
var rear_resting_ratio : float = 0.5
## Damping ratio is used to calculate the damping forces on the spring.
## A value of 1 would be critically damped. Passenger cars typically have a
## ratio around 0.3, while a race car could be as high as 0.9.
var rear_damping_ratio : float = 0.3
## Bump damping multiplier applied to the damping force calulated from the
## damping ratio. A typical ratio for a passenger car is 2/3 bump damping to
## 3/2 rebound damping. Race cars typically run 3/2 bump to 2/3 rebound.
var rear_bump_damp_multiplier : float = 0.67
## Rebound damping multiplier applied to the damping force calulated from the
## damping ratio. A typical ratio for a passenger car is 2/3 bump damping to
## 3/2 rebound damping. Race cars typically run 3/2 bump to 2/3 rebound.
var rear_rebound_damp_multiplier : float = 1.3
#OLD CODE I THINK BELOW
var PLAYER_MAX_STEER        : float = 40.0 ## Degrees.
var PLAYER_WHEEL_TURN_SPEED : float =  0.8 ## 2.5 is really good handling, 1.5 is okay handling, 0.5 is shit handling.

var PLAYER_BODY_LEAN_HELP : float = 25.0 ## In degrees.


var PLAYER_ENGINE_FORWARDS_POWER  : float = 12000.0
var PLAYER_ENGINE_BACKWARDS_POWER : float = 12000.0


var PLAYER_CAMERA_FOLLOW_AMOUNT      : float = 20.0
var PLAYER_CAMERA_INTERPOLATE_AMOUNT : float =  5.0

var PLAYER_CAMERA_LEAN_RATIO : float = 50.0 ## Is divided by local x linear_velocity.

var PLAYER_CAMERA_FORWARD_MIN  : float = 5.0
var PLAYER_CAMERA_BACKWARD_MIN : float = -6.0

var PLAYER_CAMERA_MAX_ROLL_ROTATION : float = 30.0 ## In degrees.
var PLAYER_MAX_SPEED : float = 80.0 ## Miles the per hour per eagle per fooball field per AR-15 magazines.
#countdown
var countdown: int = 300
func _process(delta: float) -> void:
	if countdown < 0:
		get_tree().change_scene_to_file("res://GAMEOVER.tscn")
#endregion player.


#region // enemy. /////
## Target position for enemies to follow.
var enemy_target_position : Vector3 = Vector3.ZERO
#endregion enemy.


#region // input. /////
var mouse_captured : bool = true : set = _set_mouse_captured
#endregion input.


#region // pause. /////
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


#region // inventory. /////
var inventory : Array = []

## All items and amount of each.
var items : Dictionary[String, int] = {
	"sticks": 0,
	"apple": 0,
}

var sticks: int = 0
var apple: int = 0

@onready var item_icon = $InnerBorder/ItemIcon

var spawnable_items = [
	{"name": "apple", "texture": preload("res://inventory/Icons/icon31.png")},
	{"name": "stick", "texture": preload("res://inventory/Icons/icon9.png")},
]

@onready var inventory_slot_scene = preload("res://inventory/Scenes/Inventory_Slot.tscn")
#endregion inventory.

#endregion VARIABLES.



#region // FUNCTIONS. //////////////////////////////////////////////////////////

func _ready() -> void:
	print_rich("\n[wave amp=80.0 freq=1.0 connected=0]🚗 ROADTRIP2025 v" + ProjectSettings.get_setting("application/config/version") + "[/wave]\n\n")
	
	# Initializes the inventory with 30 slots (spread over 9 blocks per row)
	inventory.resize(2)
	
	if Engine.is_editor_hint():
		set_process_unhandled_input(false)
		set_process(false)
		return
	
	#mouse_captured = true

	# update paused, calls setters.
	paused = paused
	
	get_tree().get_root().size_changed.connect(_on_window_size_changed)


#region // input. /////
func _set_mouse_captured(value: bool) -> void:
	mouse_captured = value
	
	Input.mouse_mode = \
		Input.MOUSE_MODE_CAPTURED if value \
		else Input.MOUSE_MODE_VISIBLE
	
#endregion input.


#region // pause. /////
func toggle_pause() -> void:
	paused = !paused

func pause() -> void:
	_is_paused = true
	game_paused.emit()

func unpause() -> void:
	_is_paused = false
	game_unpaused.emit()
#endregion pause.


#region // window. /////
func _on_window_size_changed() -> void:
	pass
#endregion window.


#region // inventory. /////
## Adds an item to the inventory, returns true if successful.
func add_item(item: Dictionary):
	for i in range(inventory.size()):
		# Check if the item exists in the inventory and matches both type and effect.
		if \
				inventory[i] != null and\
				inventory[i]["name"] == item["name"]:
			
			var item_name : String = item["name"]
			
			inventory[i]["quantity"] += item["quantity"]
			item_icon = item["texture"]
			
			inventory_updated.emit()
			
			print("Item added", inventory)
			
			# Add item if name is found within the "items" Dictionary.
			if items[item_name] != null:
				items[item_name] += 1
			
			match item["name"]:
				"apple":
					apple += 1
				"sticks":
					sticks += 1
			
			return true
		elif inventory[i] == null:
			inventory[i] = item
			
			inventory_updated.emit()
			
			print("Item added", inventory)
			return true
	return false

## Removes an item from the inventory based on type and quantity.
func remove_item(item_name, quantity):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["name"] == item_name:
			inventory[i]["quantity"] -= quantity
			if item_name == "apple":
				apple -= quantity
			if item_name == "sticks":
				sticks -= quantity
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
			inventory_updated.emit()
			return true
	return false
#endregion inventory.

#endregion FUNCTIONS.
