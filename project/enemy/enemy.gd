extends CharacterBody3D

var state_machine
var speed: float = 20
var gravity = 1
var current_speed : float = 0
@onready var e_collide = $enemy_collision
@onready var p_collide = $player_collision
@onready var front = $front
@onready var raycast = $RayCast3D
@onready var nav = $NavigationAgent3D
var chase = false
func update_target_location(target_location):
	nav.set_target_position(target_location)
	self.look_at(target_location)
func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y -= 1
	#if raycast.get_collider() is Player:
		#chase = true
	#if chase == true:
	var z_dot : float = velocity.dot(transform.basis.z)
	current_speed = abs(z_dot) * 2.236936
	var current_location = global_transform.origin
	var next_location = nav.get_next_path_position()
	var new_velocity = (next_location-current_location).normalized() * speed
	velocity = velocity.move_toward(new_velocity,0.25)
	#print(current_speed)
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		speed = (speed - 22)
		p_collide.start()
		print(speed)
	if body.is_in_group("enemy"):
			speed = (speed + 5)
			e_collide.start()
			print(speed)


func _on_enemy_collision_timeout() -> void:
		speed = 20 
		print(speed)

func _on_player_collision_timeout() -> void:
	speed = 20
	print(speed)
