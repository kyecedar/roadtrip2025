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
		get_tree().change_scene_to_file("res://game/Main.tscn")

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
		
		Roadtrip.PLAYER_MAX_STEER = 90 ## Degrees.
		Roadtrip.PLAYER_WHEEL_TURN_SPEED =  8 ## 2.5 is really good handling, 1.5 is okay handling, 0.5 is shit handling.
		Roadtrip.PLAYER_BODY_LEAN_HELP = 500
		Roadtrip.PLAYER_ENGINE_FORWARDS_POWER = 50000
		Roadtrip.PLAYER_ENGINE_BACKWARDS_POWER = 100000
		Roadtrip.PLAYER_MAX_SPEED = 400 
		Roadtrip.remove_item("apple", 3)
		Roadtrip.remove_item("sticks", 5)


func _on_wheels_pressed() -> void:
	pass # Replace with function body.


func _on_suspension_pressed() -> void:
	pass # Replace with function body.
