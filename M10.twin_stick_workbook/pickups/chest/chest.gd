extends Area2D

var _pickup: PackedScene = preload("res://pickups/item/pickup.tscn")
@export var possible_items: Array[Item] = []

@onready var chest_bottom: Sprite2D = %ChestBottom
@onready var chest_top: Sprite2D = %ChestTop
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D

var _is_in_player_range := false
var _is_opened := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(func (body): 
		if body is Player:
			chest_top.modulate = Color.RED
			_is_in_player_range = true
	)
	body_exited.connect(func (body): 
		if body is Player:
			if _is_opened:
				return
			chest_top.modulate = Color.WHITE
			_is_in_player_range = false
	)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and _is_in_player_range:
		open()

func open():
	if _is_opened:
		return
	_is_opened = true
	chest_top.modulate = Color.WHITE
	var pickup: Pickup = _pickup.instantiate()
	pickup.item = possible_items.pick_random()
	pickup.monitoring = false
	add_child(pickup)
	var tween = create_tween()
	tween.tween_property(chest_top, "position:y", -40, 0.2)
	tween.parallel().tween_property(chest_top, "modulate:a", 0, 0.2)
	tween.tween_property(pickup, "position:y", 40, 0.2)
	tween.tween_callback(func ():
		collision_shape_2d.disabled = true
		pickup.monitoring = true
	)
