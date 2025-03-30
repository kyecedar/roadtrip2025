extends Control


# Scene-Tree Node references
@onready var inventory_ui = $InventoryUI
@export var item_name = ""
@export var item_texture: Texture
@export var item_quantity: int

var scene_path: String = "res://inventory/Scenes/Inventory_Item.tscn"

@onready var upgrade_text = $upgrade_text

# Variables
# Show inventory menu on "I" pressed
func _ready() -> void:
	inventory_ui.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_inventory"):
		inventory_ui.visible = !inventory_ui.visible
	if event.is_action_pressed("escape"):
		get_tree().change_scene_to_file("res://game/Main2ElectricBoogaloo.tscn")

func pickup_item(item_name: String) -> void:
	var item = {
		"quantity": 1,
		"name": item_name,
		"texture": item_texture,
		"scene_path": scene_path
	}
	
	Roadtrip.add_item(item)

func _on_shop_pressed() -> void:
	pickup_item("apple")


func _on_sticks_pressed() -> void:
	pickup_item("sticks")
#cahnges name and quantity biiich
func _on_upgrade_pressed() -> void:
	#Roadtrip.check_item("sticks","quantity")
	if Roadtrip.items["sticks"] < 5 and Roadtrip.items["apple"] < 3:
		upgrade_text.text = "You aint got enough 
		stuff dummy"
	else:
		upgrade_text.text = "cool it worked enjoy
		 your bombaclat"
		Roadtrip.front_weight_distribution = 0.65
		Roadtrip.max_torque = 2000
		Roadtrip.max_rpm = 3000
		Roadtrip.remove_item("apple", 3)
		Roadtrip.remove_item("sticks", 5)


func _on_wheels_pressed() -> void:
	pass # Replace with function body.


func _on_suspension_pressed() -> void:
	if Roadtrip.items["sticks"] < 5 and Roadtrip.items["apple"] < 3:
		upgrade_text.text = "You aint got enough 
		stuff dummy"
	else:
		upgrade_text.text = "cool it worked enjoy
		 your sussy amongus"

		Roadtrip.remove_item("apple", 3)
		Roadtrip.remove_item("sticks", 5)
		Roadtrip.front_spring_length = 0.15
## How much the spring is compressed when the vehicle is at rest.
## This is used to calculate the approriate spring rate for the wheel.
## A value of 0 would be a fully compressed spring.(normal is 0.5)
		Roadtrip.front_resting_ratio = 0.5
## Damping ratio is used to calculate the damping forces on the spring.
## A value of 1 would be critically damped. Passenger cars typically have a
## ratio around 0.3, while a race car could be as high as 0.9.
		Roadtrip.front_damping_ratio = 0.8
## Bump damping multiplier applied to the damping force calulated from the
## damping ratio. A typical ratio for a passenger car is 2/3 bump damping to
## 3/2 rebound damping. Race cars typically run 3/2 bump to 2/3 rebound.
		Roadtrip.front_bump_damp_multiplier = 1.3
## Rebound damping multiplier applied to the damping force calulated from the
## damping ratio. A typical ratio for a passenger car is 2/3 bump damping to
## 3/2 rebound damping. Race cars typically run 3/2 bump to 2/3 rebound.
		Roadtrip.front_rebound_damp_multiplier = 0.67

## The amount of suspension travel in meters. Rear suspension typically has
## more travel than the front.
		Roadtrip.rear_spring_length = 0.2
## How much the spring is compressed when the vehicle is at rest.
## This is used to calculate the approriate spring rate for the wheel.
## A value of 1 would be a fully compressed spring. With a value of 0.5 the
## suspension will rest at the center of it's length.
		Roadtrip.rear_resting_ratio = 0.5
## Damping ratio is used to calculate the damping forces on the spring.
## A value of 1 would be critically damped. Passenger cars typically have a
## ratio around 0.3, while a race car could be as high as 0.9.
		Roadtrip.rear_damping_ratio = 0.8
## Bump damping multiplier applied to the damping force calulated from the
## damping ratio. A typical ratio for a passenger car is 2/3 bump damping to
## 3/2 rebound damping. Race cars typically run 3/2 bump to 2/3 rebound.
		Roadtrip.rear_bump_damp_multiplier = 1.3
## Rebound damping multiplier applied to the damping force calulated from the
## damping ratio. A typical ratio for a passenger car is 2/3 bump damping to
## 3/2 rebound damping. Race cars typically run 3/2 bump to 2/3 rebound.
		Roadtrip.rear_rebound_damp_multiplier = 0.67
