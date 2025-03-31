extends Node3D


@export var inventory_ui : NodePath
@export var item_name = "apple"
@export var item_texture: Texture

var scene_path: String = "res://inventory/Scenes/Inventory_Item.tscn"


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print("got it")
		pickup_item()
		queue_free()

func pickup_item() -> void:
	var item = {
		"quantity": 1,
		"name": item_name,
		"texture": item_texture,
		"scene_path": scene_path
	}
	
	Roadtrip.add_item(item)
