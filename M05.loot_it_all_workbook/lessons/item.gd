extends Area2D
@export var position_offset := Vector2(0.0, 4.0)

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	play_floating_animation()
	
func _on_area_entered(ship: Area2D) -> void:
	queue_free()

func play_floating_animation() -> void:
	var tween := create_tween()
	var duration := randf_range(0.7, 1.3)
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property($Sprite2D, "position", position_offset, duration)
	tween.tween_property($Sprite2D, "position", position_offset * -1.0, duration)
	tween.set_loops()
