extends Node3D


@onready var inventory_ui = $InventoryUI
@export var item_name = "apple"
@export var item_texture: Texture

var scene_path: String = "res://inventory/Scenes/Inventory_Item.tscn"


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print("got it")
		pickup_item(item_name)
		queue_free()

func pickup_item(item_name: String) -> void:
	var item = {
		"quantity": 1,
		"name": item_name,
		"texture": item_texture,
		"scene_path": scene_path
	}
	
	Roadtrip.add_item(item)
