class_name Player extends CharacterBody2D

@export var acceleration := 500.0
@export var deceleration := 1400.0
@export var max_speed := 120.0
@export var jump_gravity := 1200.0
@export var max_gravity := 9800.0
 
@onready var _animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direction_x := signf(Input.get_axis("move_left", "move_right"))

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
	print_debug(jump_gravity)
	velocity.y += clampf(jump_gravity * delta, velocity.y, max_gravity)
	move_and_slide()
