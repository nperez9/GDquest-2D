@tool
class_name Pickup extends Area2D

@export var item: Item = null: set = set_item

@onready var _sprite2d = %Sprite2D
@onready var _audio_stream2d = %AudioStreamPlayer2D

func _ready() -> void:
	set_item(item)
	## TODO: add some idle animations
	body_entered.connect(func (body: Node2D) -> void:
		if (body is Player):
			item.use(body)
			pickup()
	)

## Add some magic on the deat
func pickup() -> void:
	## TODO: this is not working, wait for sound to play to queue free
	_audio_stream2d.play()
	queue_free()	

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
		_audio_stream2d.stream = null
	else:
		_sprite2d.texture = item.sprite
		_audio_stream2d.stream = item.sound
