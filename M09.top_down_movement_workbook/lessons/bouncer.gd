extends CharacterBody2D

@export var max_speed := 600.0
@export var acceleration := 1200.0
## In PIXELS
@export var distance_to_desscelariton := 150.0
@export var ramp_up_duration := 2.0
@export var avoidance_strength := 21000.0

var _has_ramped_up := false
var actual_max_speed := 0.0

@onready var _player: Runner = get_tree().root.get_node("TestoSceno/Runner")
@onready var _runner_visual := %RunnerVisual
@onready var _particles := %GPUParticles2D
@onready var _hitbox:= %Hitbox
@onready var _raycast:= %Raycast

func _ready() -> void:
	_hitbox.body_entered.connect(on_body_entered)

func _physics_process(delta: float) -> void:
	if not _has_ramped_up:
		_has_ramped_up = true
		var tween := create_tween()
		tween.set_ease(Tween.EASE_IN)
		tween.set_trans(Tween.TRANS_QUAD)
		tween.tween_property(self, "actual_max_speed", max_speed, ramp_up_duration)

	var target_pos := get_global_player_position()
		
	var direction := global_position.direction_to(target_pos)
	
	## NOTE: this is the steering bheibior, THIS IS IMPORTANT
	var distance := global_position.distance_to(target_pos)
	var speed := actual_max_speed
	if distance <= distance_to_desscelariton:
		speed = actual_max_speed * distance / distance_to_desscelariton
		
	var desired_velocity := direction * speed
	desired_velocity += calculate_avoidance_force() * delta
	velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	move_and_slide()
	
	# print_debug(velocity.length(), "  ",speed, " distance", distance)
	
	if velocity.length() > 190.0 || actual_max_speed != max_speed:
		var rotation_angle = rotate_toward(_runner_visual.angle, direction.orthogonal().angle(), 8.0 * delta)
		_runner_visual.angle = rotation_angle
		_raycast.rotation = rotation_angle
		
		var current_speed_percent := velocity.length() / actual_max_speed
		_runner_visual.animation_name = (
			RunnerVisual.Animations.WALK
			if current_speed_percent < 0.8
			else RunnerVisual.Animations.RUN
		)
		
		_particles.emitting = true
	else:
		_runner_visual.animation_name = RunnerVisual.Animations.IDLE
		_particles.emitting = false
		
func stop_bouncer() -> void:
	_runner_visual.animation_name = RunnerVisual.Animations.IDLE
	_particles.emitting = false
	
func on_body_entered(body: Node2D) -> void:
	if body is Runner:
		print_debug("Deathto")
		get_tree().reload_current_scene.call_deferred()
		
## Returns the player's global position if the Runner node exists in the scene.
## Falls back to the mouse position otherwise (useful for testing without a player).
func get_global_player_position() -> Vector2:
	if _player:
		return _player.global_position
	return get_global_mouse_position()

## Calculate the force for evading objecs
func calculate_avoidance_force() -> Vector2:
	var avoidance_force := Vector2.ZERO
	
	for raycast: RayCast2D in _raycast.get_children():
		if raycast.is_colliding():
			var collision_position := raycast.get_collision_point()
			## que te direction to the opposite direction
			var direction_away_from_obstacle := collision_position.direction_to(raycast.global_position)
			var force := direction_away_from_obstacle * avoidance_strength
			avoidance_force += force
	
	return avoidance_force
