extends CharacterBody2D

@export var max_speed := 600.0
@export var acceleration := 1200.0
@export var deacceleration := 1080.0

@onready var _runner_visual := %RunnerVisual
@onready var _particles := %GPUParticles2D

signal walked_to

func _physics_process(delta: float) -> void:
	## TODO: Here should be the IA brain
	var mouse_pos := get_global_mouse_position()
	var direction := global_position.direction_to(mouse_pos)
	
	## NOTE: this is the steering bheibior, THIS IS IMPORTANT
	var distance := position.distance_to(mouse_pos)
	var speed := max_speed if distance > 100 else max_speed * distance / 100
	
	var has_input_direction := direction.length() > 0.0
	
	var desired_velocity := direction * speed
	velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	if has_input_direction:
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
