extends Node3D
@onready var rng = RandomNumberGenerator.new()
@onready var zero = $spawning_node
@onready var one = $spawning_node2
@onready var two = $spawning_node3 
@onready var three = $spawning_node4
@onready var gas = $gas
@onready var resource = $resource
func _ready() -> void:
	var my_random_number = rng.randi_range(0, 1)
	if my_random_number == 0:
		gas.set_position(zero.global_position)
		resource.set_position(one.global_position)
	if my_random_number == 1:
		gas.set_position(two.global_position)
		resource.set_position(three.global_position)
