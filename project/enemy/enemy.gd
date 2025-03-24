extends CharacterBody3D

## If the enemy will chase the player or not.
enum States {IDLE, CHASE, COOLDOWN}

# This variable keeps track of the character's current state.
var state: States = States.IDLE


@onready var e_collide : Timer = $enemy_collision
@onready var p_collide : Timer = $player_collision
@onready var front : Node3D = $front
@onready var raycast : RayCast3D = $RayCast3D
@onready var nav : NavigationAgent3D = $NavigationAgent3D
@onready var animation_player = $AnimationPlayer
@onready var spotted_finished = false
#@onready var enemy_body = $Area3D
var state_machine
var speed : float = 8.0
var gravity : float = 3.0
var current_speed : float = 0.0

func update_target_location(target_location: Vector3) -> void:
	nav.set_target_position(target_location)
	look_at(target_location)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y -= 3.0
	#STATE MACHEENE
	if state == States.CHASE:
		update_target_location(Roadtrip.enemy_target_position)
		var z_dot : float = velocity.dot(transform.basis.z)
		current_speed = abs(z_dot)
		var current_location : Vector3 = global_transform.origin
		var next_location : Vector3 = nav.get_next_path_position()
		var new_velocity : Vector3 = (next_location-current_location).normalized() * speed
		velocity = velocity.move_toward(new_velocity,0.05)
		print(current_speed) 
		move_and_slide()
	if state == States.COOLDOWN:
		update_target_location(Roadtrip.enemy_target_position)
		var z_dot : float = velocity.dot(transform.basis.z)
		var current_location : Vector3 = global_transform.origin
		var next_location : Vector3 = nav.get_next_path_position()
		var new_velocity : Vector3 = (next_location-current_location).normalized() * speed
		velocity = velocity.move_toward(new_velocity,0.05)
		speed =  -5
	#	enemy_body.set_collision_layer(2)
		move_and_slide()
	move_and_slide()
	


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		state = States.COOLDOWN
		p_collide.start()
	
	if body.is_in_group("enemy"):
		speed += 1.0
		e_collide.start()

func _on_enemy_collision_timeout() -> void:
	speed = 8

func _on_player_collision_timeout() -> void:
	speed = 8
	state = States.CHASE
	
func set_state(new_state: int) -> void:
	var previous_state := state
	state = new_state

	# You can check both the previous and the new state to determine what to do when the state changes. This checks the previous state.
	if previous_state == States.IDLE:
		pass
	if previous_state == States.CHASE:
		pass
		#animation_player.play("cooldown")

func _on_detection_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		animation_player.play("spotted_player")
		state = States.CHASE


func _on_animation_player_animation_finished(spotted_player) -> void:
	spotted_finished = true
