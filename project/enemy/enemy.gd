extends CharacterBody3D

## If the enemy will chase the player or not.
@export var active : bool = true :
	set(value):
		active = value
		
		set_physics_process(active)


@onready var e_collide : Timer = $enemy_collision
@onready var p_collide : Timer = $player_collision
@onready var front : Node3D = $front
@onready var raycast : RayCast3D = $RayCast3D
@onready var nav : NavigationAgent3D = $NavigationAgent3D

var state_machine
var speed : float = 20.0
var gravity : float = 1.0
var current_speed : float = 0.0

var chase = false


func _ready() -> void:
	# 
	active = active
	pass


func update_target_location(target_location: Vector3) -> void:
	nav.set_target_position(target_location)
	look_at(target_location)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y -= 1.0
	
	update_target_location(Roadtrip.enemy_target_position)
	
	#if raycast.get_collider() is Player:
		#chase = true
	#if chase == true:
	var z_dot : float = velocity.dot(transform.basis.z)
	
	current_speed = abs(z_dot) * 2.236936
	
	var current_location : Vector3 = global_transform.origin
	var next_location : Vector3 = nav.get_next_path_position()
	var new_velocity : Vector3 = (next_location-current_location).normalized() * speed
	
	velocity = velocity.move_toward(new_velocity,0.25)
	
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		speed -= 22.0
		p_collide.start()
	
	if body.is_in_group("enemy"):
		speed += 5.0
		e_collide.start()


func _on_enemy_collision_timeout() -> void:
	speed = 20.0

func _on_player_collision_timeout() -> void:
	speed = 20.0
