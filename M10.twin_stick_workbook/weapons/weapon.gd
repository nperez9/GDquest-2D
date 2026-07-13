## Handles fire
@tool
extends Node2D

@export var bullet_scene: PackedScene = preload("res://weapons/bullet.tscn")
## Maximum random angle applied to the shot bullets. Controls the gun's precision.
@export_range(0.0, 10.0, 1.0, "radians_as_degrees") var spread_angle := 7.0
## Maximum range a bullet can travel before it disappears.
@export_range(100.0, 2000.0, 1.0) var max_range := 2000.0
## The speed of the shot bullets
@export_range(100.0, 3000.0, 1.0) var max_bullet_speed := 1500.0

var _fire_direction = Vector2.ZERO

func set_direction(dir: Vector2) -> void:
	_fire_direction = dir
	
func _physics_process(_delta: float) -> void:
	# Apparantly this generates a bug when were using a fire
	if Engine.is_editor_hint():
		return
	if Input.is_action_just_pressed("fire"):
		shoot()


## Makes the weapon shoot once. Override this function in scripts that inherit
## from this to create new weapons.
func shoot() -> void:
	var bullet: BaseBullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)

	bullet.global_position = global_position
	bullet.global_rotation = global_rotation
	bullet.set_max_range(max_range)
	bullet.set_speed(max_bullet_speed)
	bullet.set_spread(spread_angle)
	bullet.set_direction(_fire_direction.normalized())	
	
func _get_configuration_warnings() -> PackedStringArray:
	var warnings = PackedStringArray()

	if max_bullet_speed <= 0:
		warnings.append("Bullet speed is 0 or less. It won't move!")
	
	if bullet_scene == null:
		warnings.append("You don´t have any bullets")
	else: 
		var temp = bullet_scene.instantiate()
		if not temp is BaseBullet:
			warnings.append("The bullet scene is not a bullet ")

	return warnings
