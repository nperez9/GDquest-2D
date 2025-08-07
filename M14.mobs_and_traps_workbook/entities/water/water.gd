@tool
extends ColorRect


func _ready() -> void:
	resized.connect(func(): _set_ratio())


func _set_ratio() -> void:
	material.set_shader_parameter("height", size.y)
	material.set_shader_parameter("ratio", size.x / size.y)
