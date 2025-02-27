extends Area3D




func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		get_tree().change_scene_to_file("res://inventory/Scenes/inventory_test.tscn")
func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("escape"):
		get_tree().change_scene_to_file("res://game/Main.tscn")
