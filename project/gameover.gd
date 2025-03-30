extends Control
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
func _on_button_pressed():
	get_tree().change_scene_to_file("res://game/Main2ElectricBoogaloo.tscn")
	print("restart")
