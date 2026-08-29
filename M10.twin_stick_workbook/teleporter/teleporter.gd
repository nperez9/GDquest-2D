class_name Teleporter extends Area2D

var win_fn: Callable
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(func (body): 
		print("body entered")
		if body is Player:
			print("Player won")
			win_fn.call()
	)
	
func set_win_fn(fn: Callable) -> void:
	win_fn = fn
