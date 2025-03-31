extends Control

@export var vehicle : Vehicle

@onready var speed_label = $VBoxContainer/Speed
@onready var rpm_label   = $VBoxContainer/RPM
@onready var gear_label  = $VBoxContainer/Gear
@onready var countdown_label  = $VBoxContainer/Countdown
@onready var unstuck_label = $VBoxContainer/unstuck
@onready var unstuck_timer = $"../unstuck_timer"
var stuck = false
@export var max_random_force = 1000000
func _process(_delta: float) -> void:
	speed_label.text = str(round(vehicle.speed * 3.6)) + " km/h"
	rpm_label.text = str(round(vehicle.motor_rpm)) + " rpm"
	gear_label.text = "Gear: " + str(vehicle.current_gear)
	countdown_label.text = (str(round(Roadtrip.countdown)))
	if vehicle.speed < 1:
		unstuck_timer.start()
		unstuck_label.text = ("hit space to unstuck!")
		stuck = true
	else:
		unstuck_label.text = ("")
		stuck = false
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("unstuck") and stuck == true:
		print("blah")
		var rng = RandomNumberGenerator.new()
		var random_direction = [-1,1,1]
		var force = Vector3.ZERO
		force.x = rng.randi_range(10, max_random_force) * random_direction.pick_random()
		force.z = rng.randi_range(10, max_random_force) * random_direction.pick_random()
		force.y = rng.randi_range(10, max_random_force) * random_direction.pick_random()
		vehicle.apply_torque(force)
	else:
		null
		


func _on_unstuck_timer_timeout() -> void:
	pass # Replace with function body.
