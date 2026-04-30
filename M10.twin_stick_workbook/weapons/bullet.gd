class_name BaseBullet extends Area2D

@export var speed := 800.0
@export var distance := 4000

var direction := Vector2.RIGHT
var asd := Vector2.ZERO
var target_pos := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_pos = direction.normalized() * distance


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	global_position = global_position.move_toward(target_pos, speed * delta)
	
	if global_position == target_pos:
		queue_free()
	
	
