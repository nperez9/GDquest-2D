class_name HandsHandler extends Node2D

func _process(delta: float) -> void:
	var mouse = get_global_mouse_position()
	var direction_to_mouse = global_position.direction_to(mouse)
	rotation = direction_to_mouse.angle()
	%Weapon.set_direction(direction_to_mouse)
	
