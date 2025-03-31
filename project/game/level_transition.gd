extends Area3D


@export_file("*.tscn") var scene_when_entered : String


func _on_body_entered(body: Node3D) -> void:
	if body.name == "VehicleRigidBody":
		Roadtrip.change_scene_to(scene_when_entered)
