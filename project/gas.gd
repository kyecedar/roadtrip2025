extends Node3D
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print("got it")
		Roadtrip.countdown += 15
		queue_free()
