extends Area2D
@export var base_thickness = 3.0
@export var hover_thickness = 6.0
@export var possible_items: Array[PackedScene] = []

@onready var canvas_group: CanvasGroup = $CanvasGroup

var isOpen = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	_set_thickness(base_thickness)
	
func _input_event(viewport: Viewport, event: InputEvent, shape_index: int):
	var event_is_mouse_click = ( 
		event is InputEventMouseButton && 
		event.button_index == MOUSE_BUTTON_LEFT &&
		event.is_pressed()
	)
	
	if event_is_mouse_click:
		open()

func open() -> void:
	## return animation_player.assigned_animation == "open"|| other way
	$AnimationPlayer.play("open")
	
	## BUILT IN TO SKIP this
	input_pickable = false
	
	if possible_items.is_empty():
		print("NO items on this chest")
		return
	## this will loop between 1 or three times
	for index in range(randi_range(1, 3)):
		_spawn_random_item()
	# Other cody way to do it
	# isOpen = true
	# mouse_entered.disconnect(_on_mouse_entered)
	# mouse_exited.disconnect(_on_mouse_exited)
	# _on_mouse_exited()

func _on_mouse_entered() -> void:
	_set_tweenked_thicknesss(base_thickness, hover_thickness, 0.1)

func _on_mouse_exited() -> void:
	_set_tweenked_thicknesss(hover_thickness, base_thickness, 0.1)

func _set_thickness(thickness: float) -> void:
	canvas_group.material.set_shader_parameter("line_thickness", thickness)

func _set_tweenked_thicknesss(from: float, to: float, duration: float) -> void:
	## theewns the prop values trought the duration
	var tween = create_tween()
	tween.tween_method(_set_thickness, from, to, duration)
	
func _spawn_random_item() -> void:
	## betwenn 0 and 360 degrees in radials
	var random_angle := randf_range(0.0, 2.0 * PI)
	## convert the angle into a direction, use of +x for conventio
	var random_direction := Vector2(1.0, 0.0).rotated(random_angle)
	## distance of the item to fly away
	var random_distance := randf_range(60.0, 130.0)
	var itemPosition := random_direction * random_distance
	
	var loot_item: Area2D = possible_items.pick_random().instantiate()
	add_child(loot_item)
	var tween = create_tween()
	tween.tween_property(loot_item, "position", itemPosition, 0.3)
	
## !IMPORTANT
## When you create a tween, it's a throwaway thing. You create the tween, use it, and then forget about it. Calling a function like tween_method() registers an animation for the engine to run, and when the animation ends, the engine erases the tween from memory for us.
## Because the engine erases the tween from memory, we can't keep a reference to it in a variable. If we did, we would have a reference to an object that no longer exists, which would cause an error when we try to use it.
## That's why we create the tween directly in the functions where we use it.
