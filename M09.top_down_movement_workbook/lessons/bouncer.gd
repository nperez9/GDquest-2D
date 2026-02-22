extends CharacterBody2D

@export var max_speed := 600.0
@export var acceleration := 1200.0
## In PIXELS
@export var distance_to_desscelariton := 150.0
@export var ramp_up_duration := 2.0

var _has_ramped_up := false
var actual_max_speed := 0.0

@onready var _player: Runner = get_tree().root.get_node("TestoSceno/Runner")
@onready var _runner_visual := %RunnerVisual
@onready var _particles := %GPUParticles2D
@onready var _hitbox:= %Hitbox

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
	velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	move_and_slide()
	
	# print_debug(velocity.length(), "  ",speed, " distance", distance)
	
	if velocity.length() > 200.0 || actual_max_speed != max_speed:
		_runner_visual.angle = rotate_toward(_runner_visual.angle, direction.orthogonal().angle(), 8.0 * delta)
		
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
