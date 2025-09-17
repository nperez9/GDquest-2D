extends Area2D

@onready var animation_player: AnimationPlayer = $"AnimationPlayer"


func _input_event(viewport: Viewport, event: InputEvent, shape_index: int):
	# Complete this boolean expression to check if the input event is a left-mouse click.
	var event_is_mouse_click: bool = (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
	)

	if event_is_mouse_click:
		animation_player.play("open")
		input_pickable = false
