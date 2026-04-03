extends CharacterBody2D

@export var max_speed := 600.0
@export var acceleration := 1200.0
## In PIXELS
@export var distance_to_desscelariton := 150.0
@export var ramp_up_duration := 2.0
@export var avoidance_strength := 21000.0
@export var max_avoidance_force := 15000.0

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

## Calculate the force for evading objects using free-ray steering
func calculate_avoidance_force() -> Vector2:
	var free_direction := Vector2.ZERO
	var wall_normal := Vector2.ZERO
	var blocked_count := 0.0
	var total_count := 0

	for raycast: RayCast2D in _raycast.get_children():
		total_count += 1
		if raycast.is_colliding() and not raycast.get_collider() is Runner:
			blocked_count += 1
			wall_normal += raycast.get_collision_normal()
		else:
			var ray_dir := Vector2.from_angle(raycast.global_rotation)
			var forward_dir := Vector2.from_angle(_raycast.global_rotation)
			var alignment := (ray_dir.dot(forward_dir) + 1.0) * 0.5
			var weight := 0.5 + alignment * 0.5
			free_direction += ray_dir * weight

	if blocked_count == 0.0:
		return Vector2.ZERO

	var block_ratio := float(blocked_count) / float(total_count)

	# Fallback: if free_direction is near zero (head-on wall hit), slide along the wall
	if free_direction.length() < 0.1:
		wall_normal = wall_normal.normalized()
		var wall_tangent := Vector2(-wall_normal.y, wall_normal.x)
		# Pick the tangent direction that leads toward the player
		var to_player := global_position.direction_to(get_global_player_position())
		if wall_tangent.dot(to_player) < 0.0:
			wall_tangent = -wall_tangent
		return (wall_tangent * avoidance_strength).limit_length(max_avoidance_force)

	# Normal case: steer toward free space
	var avoidance_force := free_direction.normalized() * avoidance_strength * block_ratio

	# Blend with current velocity direction to avoid wild turns
	if velocity.length() > 10.0:
		var move_dir := velocity.normalized()
		avoidance_force = avoidance_force.lerp(move_dir * avoidance_force.length(), 0.3)

	return avoidance_force.limit_length(max_avoidance_force)
