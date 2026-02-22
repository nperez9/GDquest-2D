extends RayCast2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var target_pos = get_global_mouse_position()
	target_position = target_pos
	if is_colliding():
		print_debug(get_collision_point())
		print_debug(get_collider())
