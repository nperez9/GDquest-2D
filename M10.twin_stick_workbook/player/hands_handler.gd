## Handles rotation, and weapon movement
# DO not handle fire
class_name HandsHandler extends Node2D

var is_using_gamepad := false
var aim_direction := Vector2.ZERO

## Coll stuff to handle controller or mouse in live
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion or event is InputEventKey:
		is_using_gamepad = false
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		is_using_gamepad = true


func _process(delta: float) -> void:
	if is_using_gamepad:
		aim_direction = Input.get_vector("aim-left", "aim-right", "aim-up", "aim-down")
	else:
		var mouse_pos = get_global_mouse_position()
		aim_direction = global_position.direction_to(mouse_pos)
	rotation = aim_direction.angle()
	%Weapon.set_direction(aim_direction)
	
	z_index = 3
	if aim_direction.y < 0.0:
		z_index = 1
	
