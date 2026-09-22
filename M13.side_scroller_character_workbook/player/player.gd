
class_name Player extends CharacterBody2D

@export var acceleration := 500.0
@export var deceleration := 1400.0
@export var air_acceleration := 500.0
@export var max_speed := 120.0
@export var jump_gravity := 1200.0
@export var max_gravity := 9800.0
@export var jump_force := 380.0

@onready var _animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

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

func _physics_process(delta: float) -> void:
	direction_x = signf(Input.get_axis("move_left", "move_right"))
	
	match _current_state:
		State.GROUND:
			process_ground_state(delta)
		State.JUMP:
			process_jump_state(delta)
		State.FALL:
			process_fall_state(delta)

	velocity.y += jump_gravity * delta
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
			velocity.y = -1 * jump_force
			_animated_sprite_2d.play("jump")
		State.FALL:
			_animated_sprite_2d.play("fall")
