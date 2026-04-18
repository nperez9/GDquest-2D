class_name Player extends CharacterBody2D


const SPEED = 300.0
const MAX_SPEED = 600.0
const ACCLERATION = 1200.0
const DEACCELERATION = 1300.0

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move-left", "move-right", "move-up", "move-down")
	var has_input_direction := direction.length() > 0.0
	if has_input_direction:
		var desired_velocity = direction * MAX_SPEED
		velocity = velocity.move_toward(desired_velocity, ACCLERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * DEACCELERATION)
	move_and_slide()
