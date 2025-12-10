@icon("res://assets/dialogue_item_icon.svg")
class_name DialogEntry extends SlideShowEntry

@export var choices: Array[DialogChoice] = []

func set_dialogue_items(new_dialogue_items: Array[DialogEntry]) -> void:
	for index in new_dialogue_items.size():
		if new_dialogue_items[index] == null:
			new_dialogue_items[index] = DialogEntry.new()
	dialogue_items = new_dialogue_items
