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
		Roadtrip.front_weight_distribution = 0.7
		Roadtrip.max_torque = 2000
		Roadtrip.max_rpm = 3000
		Roadtrip.remove_item("apple", 3)
		Roadtrip.remove_item("sticks", 5)


func _on_wheels_pressed() -> void:
	pass # Replace with function body.


func _on_suspension_pressed() -> void:
	pass # Replace with function body.
