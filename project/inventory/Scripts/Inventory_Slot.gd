### Inventory_Slot.gd

extends Control

# Scene-Tree Node references
@onready var icon = $InnerBorder/ItemIcon
@onready var quantity_label = $InnerBorder/ItemQuantity

# Slot item
var item = null

# Default empty slot
func set_empty():
	icon.texture = null
	quantity_label.text = ""

# Set slot item with its values from the dictionary
func set_item(new_item):
	item = new_item
	icon.texture = item["texture"] 
	quantity_label.text = str(item["quantity"])
