class_name Runner extends CharacterBody2D

@export var max_speed := 600.0
@export var acceleration := 1200.0
@export var deacceleration := 1080.0

@onready var _runner_visual := %RunnerVisualRed
@onready var _particles := %GPUParticles2D

signal walked_to

## Match stuff
#const UP_LEFT = Vector2.UP + Vector2.LEFT
#const UP_RIGHT = Vector2.UP + Vector2.RIGHT
#const DOWN_LEFT = Vector2.DOWN + Vector2.LEFT
#const DOWN_RIGHT = Vector2.DOWN + Vector2.RIGHT

## Sprites Const
#const RUNNER_DOWN = preload("res://assets/runner_down.png")
#const RUNNER_DOWN_RIGHT = preload("res://assets/runner_down_right.png")
#const RUNNER_RIGHT = preload("res://assets/runner_right.png")
#const RUNNER_UP = preload("res://assets/runner_up.png")
#const RUNNER_UP_RIGHT = preload("res://assets/runner_up_right.png")

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var has_input_direction := direction.length() > 0.0
	if has_input_direction:
		## vector 2 with the max vel (distance)
		var desired_velocity := direction * max_speed
		## Even with fixed physics process, seems to be a good idea use * delta in movement
		velocity = velocity.move_toward(desired_velocity, delta * acceleration)
		## no use of this line, but other way to get it
		var current_speed_percent := velocity.length() / max_speed
		if velocity.length() > max_speed * 0.9:
			_particles.emitting = true
			_runner_visual.set_animation_name(RunnerVisual.Animations.RUN)
		else:
			_particles.emitting = false
			_runner_visual.set_animation_name(RunnerVisual.Animations.WALK)
		## gets the current velocity 
		#print(velocity.length())
	else:
		## stops! slowly fades
		_runner_visual.set_animation_name(RunnerVisual.Animations.WALK)
		velocity = velocity.move_toward(Vector2.ZERO, delta * deacceleration)
	
	if (direction.length() > 0.0):
		_runner_visual.angle = rotate_toward(_runner_visual.angle, direction.orthogonal().angle(), 8.0 * delta)
		## ort for 90 degress charcater conversion, moves from current angle to target angle by 8.0 radials per second
	
	if velocity.length() == 0.0:
		_particles.emitting = false
		_runner_visual.set_animation_name(RunnerVisual.Animations.IDLE)
	move_and_slide()
	
	## normalize to absolute values to use the match (like a switch)
	var direction_discrete := direction.sign()
	
func walk_to(destination_global_position: Vector2) -> void:
	var direction := global_position.direction_to(destination_global_position)
	_runner_visual.angle = direction.orthogonal().angle()
	## Fake walking
	_runner_visual.set_animation_name(RunnerVisual.Animations.WALK)
	_particles.emitting = true
	
	var distance := global_position.distance_to(destination_global_position)
	var duration := distance / (max_speed * 0.3)
	var tween := create_tween()
	tween.tween_property(self, "global_position", destination_global_position, duration)
	tween.finished.connect(func():
		_runner_visual.set_animation_name(RunnerVisual.Animations.IDLE)
		_particles.emitting = false
		_runner_visual.angle = 0
		walked_to.emit()
	)


## OLD match version for changing sprites
	#match direction_discrete:
	#Vector2.RIGHT, Vector2.LEFT:
		#_skin.texture = RUNNER_RIGHT
	#Vector2.UP:
		#_skin.texture = RUNNER_UP
	#Vector2.DOWN:
		#_skin.texture = RUNNER_DOWN
	#UP_LEFT, UP_RIGHT:
		#_skin.texture = RUNNER_UP_RIGHT
	#DOWN_RIGHT, DOWN_LEFT:
		#_skin.texture = RUNNER_DOWN_RIGHT
	#if direction_discrete.length() > 0.0:
		#_skin.flip_h = direction_discrete.x < 0.0
	
	## OLD elif version
	#if (direction.x < 0.0 && direction.y < 0.0):
		#_skin.texture = RUNNER_UP_LEFT
	#elif (direction.x > 0.0 && direction.y < 0.0):
		#_skin.texture = RUNNER_UP_RIGHT
	#elif (direction.x > 0.0 && direction.y > 0.0):
		#_skin.texture = RUNNER_DOWN_RIGHT
	#elif (direction.x < 0.0 && direction.y > 0.0):
		#_skin.texture = RUNNER_DOWN_LEFT
	#elif (direction.x > 0.0):
		#_skin.texture = RUNNER_RIGHT
	#elif (direction.x < 0.0):
		#_skin.texture = RUNNER_LEFT
	#elif (direction.y < 0.0):
		#_skin.texture = RUNNER_UP
	#elif (direction.y > 0.0):
		#_skin.texture = RUNNER_DOWN
