extends Sprite2D

const SPRITE_UP := preload("res://player/godot_up.png")
const SPRITE_UP_RIGHT := preload("res://player/godot_up_right.png")
const SPRITE_RIGHT := preload("res://player/godot_right.png")
const SPRITE_DOWN_RIGHT := preload("res://player/godot_bottom_right.png")
const SPRITE_DOWN := preload("res://player/godot_bottom.png")

const UP_RIGHT := Vector2(1, -1)
const UP_LEFT := Vector2(-1, -1)
const DOWN_RIGHT := Vector2(1, 1)
const DOWN_LEFT := Vector2(-1, 1)


func _process(_delta: float) -> void:
	var direction := Input.get_vector("move-left", "move-right", "move-up", "move-down")
	var direction_discrete := direction.sign()

	match direction_discrete:
		Vector2.RIGHT, Vector2.LEFT:
			texture = SPRITE_RIGHT
		Vector2.UP:
			texture = SPRITE_UP
		Vector2.DOWN:
			texture = SPRITE_DOWN
		UP_RIGHT, UP_LEFT:
			texture = SPRITE_UP_RIGHT
		DOWN_RIGHT, DOWN_LEFT:
			texture = SPRITE_DOWN_RIGHT

	if direction_discrete.length() > 0:
		flip_h = direction_discrete.x < 0.0
