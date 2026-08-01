@tool
class_name Pickup extends Area2D

@export var item: Item = null: set = set_item

@onready var _sprite2d = %Sprite2D
@onready var _audio_stream2d = %AudioStreamPlayer2D
@onready var shadow_circle: Sprite2D = %ShadowCircle

func _ready() -> void:
	set_item(item)
	if Engine.is_editor_hint():
		return

	var tween := create_tween().set_loops()
	tween.tween_property(_sprite2d, "position:y", -6.0, 0.8).as_relative().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(_sprite2d, "position:y", 6.0, 0.8).as_relative().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	body_entered.connect(func (body: Node2D) -> void:
		if (body is Player):
			item.use(body)
			pickup()
	)
	_audio_stream2d.finished.connect(func () -> void:
		queue_free()
	)
	

## Add some magic on the deat
func pickup() -> void:
	_audio_stream2d.play()
	_sprite2d.visible = false
	shadow_circle.visible = false
	set_deferred("monitoring", false)

func set_item(new_item: Item) -> void:
	item = new_item
	if not is_node_ready():
		# set_item() can be called before the node is ready;
		# exit early in that case
		return
	if item == null:
		# The item property is null when the Pickup is first added to the scene
		# or if the item is removed from the slot
		_sprite2d.texture = null
		shadow_circle.visible = false
		_audio_stream2d.stream = null
	else:
		_sprite2d.texture = item.sprite
		shadow_circle.visible = true
		_audio_stream2d.stream = item.sound
