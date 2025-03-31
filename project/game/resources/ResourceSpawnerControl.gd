extends Node3D

@onready var rng = RandomNumberGenerator.new()


## Stock of each resource in level.[br]
## For example, if there was only 6 gas canisters in a level, it'd be represented as {"Gas": 6} within the Dictionary.[br]
## Make sure the name of the resource matches everywhere, like "Gas" shouldn't be "GasCanister" somewhere else.
@export var default_stock : Dictionary[String, int] = {}

@onready var zero  : Node3D = $ResourceSpawner1
@onready var one   : Node3D = $ResourceSpawner2
@onready var two   : Node3D = $ResourceSpawner3
@onready var three : Node3D = $ResourceSpawner4

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
	
	init()

## Initialize resource positions.
func init() -> void:
	var resources_in_stock : Array[String] = default_stock.keys()
	var stock_of_resources : Array = [] ## Array[Array[String(name of resource),int(count of resource)]]
	
	for resource_name in resources_in_stock:
		stock_of_resources.append([resource_name, default_stock[resource_name]])
	
	var spawner_nodes : Array[Node] = get_tree().get_nodes_in_group(&"ResourceSpawner")
	
	# loop through every spawner node.
	# if in stock, roll chance to add it, then subtract from stock.
	# if no more in stock for that resource, then remove from "resources_in_stock".
	for node in spawner_nodes:
		# get random number from 0 to length of "resources_in_stock" minus 1.
		
		pass

## Creates a WorldResource at node position.
func create_worldresource_at(position: Vector3) -> void:
	pass

## Destroys all spawned resources.
func clear_resources() -> void:
	pass
