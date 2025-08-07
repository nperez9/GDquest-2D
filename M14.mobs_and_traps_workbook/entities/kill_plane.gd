@tool
class_name KillPlane2D extends Area2D


func _ready() -> void:
	collision_layer = 2
	collision_mask = 1
	monitoring = true

	var collision_shape := CollisionShape2D.new()
	var shape := WorldBoundaryShape2D.new()
	collision_shape.shape = shape
	add_child(collision_shape)

	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.die()
