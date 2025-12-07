## adding a class name make it accsessible from anyway
class_name SlideShowEntry extends Resource

@export_category("Character Images")
@export var character: Texture = preload("res://assets/sophia.png")
@export var expression: Texture = preload("res://assets/emotion_regular.png")

@export_category("Setting up")
@export_multiline var text: String = ""
