class_name BaseBullet extends Area2D

var _speed := 1200.0
var _max_range := 2000
var _spread := 7.0 # Degrees of random spread

var direction := Vector2.ZERO
var traveled_distance := 0.0

func set_speed(speed: int) -> void:
	_speed = speed
	
func set_max_range(max_range: int) -> void:
	_max_range = max_range

## Reccomended value between 0 and 10 
func set_spread(spread: float) -> void:
	_spread = spread

## TODO Relyes in order for spread, fix this 
func set_direction(dir: Vector2) -> void:
	var random_rad = deg_to_rad(randf_range(-_spread, _spread))	
	# 2. Apply rotation to the base direction and normalize
	direction = dir.rotated(random_rad).normalized()
	rotation = direction.angle()
	
func _ready() -> void:
	body_entered.connect(bullet_collide)
	
func _process(delta: float) -> void:
	var step = direction * _speed * delta
	global_position += step
	
	# Track distance traveled instead of a fixed coordinate
	traveled_distance += step.length()
	
	if traveled_distance >= _max_range:
		_destroy()
		
func bullet_collide(body) -> void:
	if body is Mob:
		body.health = body.health - 1
		_destroy()
	
func _destroy() -> void:
	queue_free()
