
class_name Player extends CharacterBody2D

@export_category("Movement")
@export var acceleration := 500.0
@export var deceleration := 1400.0
@export var air_acceleration := 500.0
@export var max_speed := 120.0
@export var max_fall_speed := 850.0

@export_category("Jump")
@export_range(10.0, 200.0) var jump_height := 50.0
@export_range(0.1, 1.5) var jump_time_to_peak := 0.37
@export_range(0.1, 1.5) var jump_time_to_descent := 0.2

var current_gravity := 0.0

@onready var _animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var jump_speed := calculate_jump_speed(jump_height, jump_time_to_peak)
@onready var jump_gravity := calculate_jump_gravity(jump_height, jump_time_to_peak)
@onready var fall_gravity := calculate_fall_gravity(jump_height, jump_time_to_descent)

## First approach to state machines
enum State {
	GROUND,
	JUMP,
	FALL
}

var direction_x := 0.0

var _current_state: State = State.GROUND

func _ready() -> void:
	_transtition_to_state(_current_state)
	print_debug(jump_speed, " | ", jump_gravity, " | ", fall_gravity, " | ",jump_time_to_descent)

func _physics_process(delta: float) -> void:
	direction_x = signf(Input.get_axis("move_left", "move_right"))
	
	match _current_state:
		State.GROUND:
			process_ground_state(delta)
		State.JUMP:
			process_jump_state(delta)
		State.FALL:
			process_fall_state(delta)

	velocity.y += current_gravity * delta
	velocity.y = minf(velocity.y, max_fall_speed)
	move_and_slide()
	
func process_ground_state(delta: float):
	var is_moving := absf(direction_x) > 0.0
	if is_moving:
		## this not pass when its zero
		_animated_sprite_2d.flip_h = direction_x < 0.0
		velocity.x += direction_x * acceleration * delta
		velocity.x = clampf(velocity.x, -max_speed, max_speed)
		_animated_sprite_2d.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
		_animated_sprite_2d.play("idle")
	
	if Input.is_action_just_pressed("jump"):
		_transtition_to_state(State.JUMP)
	
	if !is_on_floor():
		_transtition_to_state(State.FALL)
		
func process_jump_state(delta: float):
	if direction_x != 0:
		velocity.x += air_acceleration * direction_x * delta
		velocity.x = clampf(velocity.x, -max_speed, max_speed)
		_animated_sprite_2d.flip_h = direction_x < 0.0
	else:
		velocity.x = 0
	
	if (velocity.y >= 0.0):
		_transtition_to_state(State.FALL)
		
func process_fall_state(delta: float):
	if direction_x != 0:
		velocity.x += air_acceleration * direction_x * delta
		velocity.x = clampf(velocity.x, -max_speed, max_speed)
		_animated_sprite_2d.flip_h = direction_x < 0.0
	else:
		velocity.x = 0
		
	if (is_on_floor()):
		_transtition_to_state(State.GROUND)
	
func _transtition_to_state(new_state: State) -> void:
	print("Transitioning from ", State.keys()[_current_state], " to ", State.keys()[new_state])
	var previous_state := _current_state
	_current_state = new_state
	
	## exit current state. can add things on exit that state EX: sounds, vfx
	match previous_state: 
		pass
		
	# Enter new state the same, can add things on transitio
	match _current_state:
		State.JUMP:
			velocity.y = jump_speed
			current_gravity = jump_gravity
			print_debug(current_gravity)
			_animated_sprite_2d.play("jump")
		State.FALL:
			current_gravity = fall_gravity
			print_debug(current_gravity)
			_animated_sprite_2d.play("fall")

### Phisics Stuff, Very important
func calculate_jump_speed(height: float, time_to_peak: float) -> float:
	return (-2.0 * height) / time_to_peak

func calculate_jump_gravity(height: float, time_to_peak: float) -> float:
	return (2.0 * height) / pow(time_to_peak, 2.0)

func calculate_fall_gravity(height: float, time_to_descent: float) -> float:
	return (2.0 * height) / pow(time_to_descent, 2.0)
