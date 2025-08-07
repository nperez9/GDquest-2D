class_name CrateButton extends Area2D

signal state_changed(value: bool)

@onready var button_sprite: Sprite2D = %ButtonSprite

var pressed: bool = false : set = _set_pressed


func _ready() -> void:
	body_entered.connect(func(_node: Node2D): _check_state(), CONNECT_DEFERRED)
	body_exited.connect(func(_node: Node2D): _check_state(), CONNECT_DEFERRED)


func _set_pressed(value: bool) -> void:
	if pressed == value:
		return
	pressed = value
	button_sprite.frame = int(pressed)
	state_changed.emit(pressed)


func _check_state() -> void:
	pressed = get_overlapping_bodies().any(func(node): return node is CharacterBody2D)
