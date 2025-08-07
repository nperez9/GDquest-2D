class_name Mob extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = %Sprite
@onready var ground_cast: RayCast2D = %GroundCast

var direction_x: int = -1
var walk_speed: float = 32.0
var is_dead: bool = false


func _physics_process(delta: float) -> void:
	if is_on_floor():
		if not ground_cast.is_colliding() or is_on_wall():
			_flip_direction()
		velocity.x = direction_x * walk_speed
	else:
		velocity.y = 100.0

	move_and_slide()


func die() -> void:
	if is_dead:
		return

	is_dead = true
	set_physics_process(false)
	sprite.play("hurt")
	collision_layer = 0
	collision_mask = 0

	var explosion = load("res://vfx/explosion/explosion.tscn").instantiate()
	explosion.global_position = global_position
	get_parent().add_child(explosion)

	await get_tree().create_timer(0.5).timeout
	queue_free()


func _flip_direction() -> void:
	direction_x *= -1
	ground_cast.position.x = 8.0 * direction_x
	sprite.flip_h = not sprite.flip_h


