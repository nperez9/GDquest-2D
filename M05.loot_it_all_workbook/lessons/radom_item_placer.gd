extends Node2D

@export var spawn_limit := 6
var gem_scene := preload("res://lessons/gem.tscn")
var health_scene := preload("res://lessons/health_pack.tscn")

var item_scenes: Array[PackedScene] = [
	gem_scene,
	health_scene
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.timeout.connect(_on_timeout)

func _on_timeout():
	## +1 due that we are counting the timer as a child
	if get_child_count(false) >= spawn_limit + 1:
		return
	
	## for forcing typos
	var random_item_scene: PackedScene = item_scenes.pick_random() as PackedScene
	var item_stance: Area2D = random_item_scene.instantiate()
	## IMPORTANT
	var viewport_size := get_viewport_rect().size
	## Reading the viewport size only once and storing it in a member variable might seem like a good optimization, but it can cause problems. The viewport size changes whenever the player resizes the game window or changes graphics settings, so you should read it directly from the engine every time you need it.
	## Storing the value in a variable will not improve your game's performance, and it can lead to bugs when the viewport size changes and you forget to update the variable.
	var random_pos = Vector2.ZERO
	## little offset
	random_pos.x = randf_range(40, viewport_size.x)
	random_pos.y = randf_range(40, viewport_size.y)
	item_stance.position = random_pos
	add_child(item_stance)
	
