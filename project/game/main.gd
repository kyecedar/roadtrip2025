extends Node3D

#region // PATHFINDING. ////////////////////////////////////////////////////////

@export var target : Node3D

func _process(_delta: float) -> void:
	Roadtrip.enemy_target_position = target.global_position

#endregion PATHFINDING.
