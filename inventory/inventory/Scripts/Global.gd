### Global.gd

extends Node

# Inventory items
var inventory = []

# Custom signals
signal inventory_updated
var spawnable_items = [
	{"name": "apple", "texture": preload("res://inventory/Icons/icon31.png")},
	{"name": "stick", "texture": preload("res://inventory/Icons/icon9.png")},
]
@onready var inventory_slot_scene = preload("res://inventory/Scenes/Inventory_Slot.tscn")

func _ready(): 
	# Initializes the inventory with 30 slots (spread over 9 blocks per row)
	inventory.resize(2) 

# Adds an item to the inventory, returns true if successful
func add_item(item):
	for i in range(inventory.size()):
		# Check if the item exists in the inventory and matches both type and effect
		if inventory[i] != null and inventory[i]["name"] == item["name"]:
			inventory[i]["quantity"] += item["quantity"]
			inventory_updated.emit()
			print("Item added", inventory)
			return true
		elif inventory[i] == null:
			inventory[i] = item
			inventory_updated.emit()
			print("Item added", inventory)
			return true
	return false

# Removes an item from the inventory based on type and quantity
func remove_item(item_name, quantity):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["name"] == item_name:
			inventory[i]["quantity"] -= quantity
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
			inventory_updated.emit()
			return true
	return false
