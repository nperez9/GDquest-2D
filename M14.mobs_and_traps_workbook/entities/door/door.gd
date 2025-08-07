class_name Door extends StaticBody2D

@export var button: CrateButton = null

@onready var sprite: NinePatchRect = %Sprite
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D

var height: float = 48


func _ready() -> void:
	if button:
		button.state_changed.connect(func(button_state: bool): _on_button_state_change(button_state))


func _on_button_state_change(button_state: bool) -> void:
	collision_shape_2d.set_deferred("disabled", button_state)
	var tween := create_tween()
	tween.tween_property(sprite, "size:y", 16.0 if button_state else height, 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
