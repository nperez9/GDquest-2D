class_name BaseBullet extends Area2D

@export var speed := 1200.0
@export var max_range := 2000
@export var spread := 7.0 # Degrees of random spread

var direction := Vector2.ZERO
var traveled_distance := 0.0

func set_direction(dir: Vector2) -> void:
	var random_rad = deg_to_rad(randf_range(-spread, spread))	
	# 2. Apply rotation to the base direction and normalize
	direction = dir.rotated(random_rad).normalized()
	rotation = direction.angle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var step = direction * speed * delta
	global_position += step
	
	# Track distance traveled instead of a fixed coordinate
	traveled_distance += step.length()
	
	if traveled_distance >= max_range:
		_destroy()
	
func _destroy() -> void:
	queue_free()
