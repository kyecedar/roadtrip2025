### Inventory_Item.gd
@tool
extends Node2D

# Item details for editor window
@export var item_name = ""
@export var item_texture: Texture
var scene_path: String = "res://Scenes/Inventory_Item.tscn"

# Scene-Tree Node references
@onready var icon_sprite = $Sprite2D

func _ready():
	# Set the texture to reflect in the game
	if not Engine.is_editor_hint():
		icon_sprite.texture = item_texture

func _process(_delta):
	# Set the texture to reflect in the editor
	if Engine.is_editor_hint():
		icon_sprite.texture = item_texture
# Add item to inventory
func pickup_item():
	var item = {
		"quantity": 1,
		"name": item_name,
		"texture": item_texture,
		"scene_path": scene_path
	}
	Global.add_item(item)

# Sets the item's dictionary data
func set_item_data(data):
	item_name = data["name"]
	item_texture = data["texture"]

# Set the items values for spawning
func initiate_items(name, texture):
	item_name = name
	item_texture = texture
