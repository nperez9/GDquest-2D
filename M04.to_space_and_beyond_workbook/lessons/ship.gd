extends Sprite2D

@export var normal_speed := 600
@export var dash_speed := 1200
@export var steering_factor := 10.0
var max_speed := normal_speed
var direction := Vector2.ZERO
var velocity := Vector2.ZERO

var is_dash_on_cd := false

func _process(delta: float) -> void:
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	## When the player presses only one key on a keyboard, the direction vector has a length of 1.0. 
	## This means the ship will move at the speed defined by the max_speed variable. With a gamepad and joysticks, 
	## however, the direction vector's length could be less than 1.0 and give the player more control over the ship.
	if (direction.length() > 1.0):
		direction = direction.normalized()
	if (Input.is_action_just_pressed("dash") && !is_dash_on_cd):
		max_speed = dash_speed
		is_dash_on_cd = true
		%DashTimer.start()
	
	var desired_velocity  := max_speed * direction
	var steering_vector := desired_velocity - velocity
	print_debug(steering_vector)
	
	## Without multiplying by delta, the ship would accelerate by a fixed amount each frame
	velocity += steering_vector * steering_factor * delta
	## Double delta is necessary
	position += velocity * delta
	
	if (direction.length() > 0):
		rotation = velocity.angle()
		


func _on_dash_timer_timeout() -> void:
	max_speed = normal_speed
	## REMEMBER MAKE THE TIMERS ONE SHOT
	%DashCooldown.start()


func _on_dash_cooldown_timeout() -> void:
	is_dash_on_cd = false
