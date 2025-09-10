extends Node2D

var collectible_scenes := [
	preload("res://practices/L7.P1.spawn_random_items/coin.tscn"),
	preload("res://practices/L7.P1.spawn_random_items/energy_pack.tscn")
]


func _ready() -> void:
	get_node("Timer").timeout.connect(_on_timer_timeout)


func _on_timer_timeout() -> void:
	var random_item: PackedScene = collectible_scenes.pick_random()
	add_child(random_item.instantiate())
