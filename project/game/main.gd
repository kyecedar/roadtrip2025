extends Node3D
#PATHFINDING
@onready var target = %Player
func _physics_process(delta):
	get_tree().call_group("enemy", "update_target_location", target.global_transform.origin) 
