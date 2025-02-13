extends Control
# Scene-Tree Node references
@onready var inventory_ui = $InventoryUI
@export var item_name = ""
@export var item_texture: Texture
var scene_path: String = "res://Scenes/Inventory_Item.tscn"
# Variables
# Show inventory menu on "I" pressed
func _input(event):
	if event.is_action_pressed("ui_inventory"):
		inventory_ui.visible = !inventory_ui.visible
		
func pickup_item(item_name):
	var item = {
		"quantity": 1,
		"name": item_name,
		"texture": item_texture,
		"scene_path": scene_path
	}
	Global.add_item(item)

func _on_shop_pressed() -> void:
	pickup_item("apple")


func _on_sticks_pressed() -> void:
	pickup_item("sticks")

#cahnges name and quantity biiich
func _on_upgrade_pressed() -> void:
		Global.remove_item("apple", 3)
		Global.remove_item("sticks", 5)
