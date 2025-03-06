extends Node3D
#PATHFINDING
@onready var target = $Player
func process(delta):
	get_tree().call_group("enemy", "target_position", target.global_transform.origin) 
