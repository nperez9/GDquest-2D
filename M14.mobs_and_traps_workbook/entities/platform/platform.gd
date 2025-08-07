@tool
class_name Platform extends AnimatableBody2D

@export_range(32.0, 512.0, 16.0) var width := 128.0: set = _set_width

@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var shape: RectangleShape2D = collision_shape_2d.shape
@onready var sprite: NinePatchRect = %Sprite


func _ready() -> void:
	_set_width(width)


func _set_width(value: float) -> void:
	width = value
	if not is_inside_tree():
		return
	shape.size.x = width
	sprite.position.x = -width / 2.0
	sprite.size.x = width
