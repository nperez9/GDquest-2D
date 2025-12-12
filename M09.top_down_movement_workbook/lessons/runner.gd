extends CharacterBody2D
var max_speed := 600.0
@onready var _skin = %Skin

## Match stuff
const UP_LEFT = Vector2.UP + Vector2.LEFT
const UP_RIGHT = Vector2.UP + Vector2.RIGHT
const DOWN_LEFT = Vector2.DOWN + Vector2.LEFT
const DOWN_RIGHT = Vector2.DOWN + Vector2.RIGHT

## Sprites Const
const RUNNER_DOWN = preload("res://assets/runner_down.png")
const RUNNER_DOWN_RIGHT = preload("res://assets/runner_down_right.png")
const RUNNER_RIGHT = preload("res://assets/runner_right.png")
const RUNNER_UP = preload("res://assets/runner_up.png")
const RUNNER_UP_RIGHT = preload("res://assets/runner_up_right.png")

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * max_speed
	move_and_slide()
	
	## normalize to absolute values to use the match (like a switch)
	var direction_discrete := direction.sign()
	
	match direction_discrete:
		Vector2.RIGHT, Vector2.LEFT:
			_skin.texture = RUNNER_RIGHT
		Vector2.UP:
			_skin.texture = RUNNER_UP
		Vector2.DOWN:
			_skin.texture = RUNNER_DOWN
		UP_LEFT, UP_RIGHT:
			_skin.texture = RUNNER_UP_RIGHT
		DOWN_RIGHT, DOWN_LEFT:
			_skin.texture = RUNNER_DOWN_RIGHT
			
	if direction_discrete.length() > 0.0:
		_skin.flip_h = direction_discrete.x < 0.0
	
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

func _draw() -> void:
	print("oejte")
	# Draw a red cross at the local origin (the pivot)
	var size = 10
	var color = Color(1, 0, 0) # Red
	# Horizontal line
	draw_line(Vector2(-size, 0), Vector2(size, 0), color, 2)
	# Vertical line
	draw_line(Vector2(0, -size), Vector2(0, size), color, 2)
