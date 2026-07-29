class_name Mob extends CharacterBody2D

@export var health := 3: set = set_health
@export var damage := 2

func set_health(value: int) -> void:
	health = value
	if health <= 0:
		die()

func die() -> void:
	## TODO: add more juiciness
	queue_free()

func _ready():
		pass
