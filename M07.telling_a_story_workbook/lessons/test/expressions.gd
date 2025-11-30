extends Control

var bodies := {
	"sofia": preload("res://assets/sophia.png"),
	"pink": preload("res://assets/pink.png")
}

var expressions := {
	"regular": preload("res://assets/emotion_regular.png"),
	"sad": preload("res://assets/emotion_sad.png"),
	"happy": preload("res://assets/emotion_happy.png")
}

@onready var character: TextureRect = %Character
@onready var eyes_with_a_face: TextureRect = %EyesWithAFace
@onready var expressions_row: HBoxContainer = %ExpressionsRow
@onready var body_row: HBoxContainer = %BodyRow

var current_state := {
	"body": null,
	"expression": null
}

func _ready() -> void:
	character.texture = bodies["sofia"]
	eyes_with_a_face.texture = expressions["regular"]
	create_buttons()

func change_body(body_key: String) -> void:
	character.texture = bodies[body_key]

func change_expression(expression_key: String) -> void:
	eyes_with_a_face.texture = expressions[expression_key]

func create_buttons() -> void:
	for body_key: String in bodies.keys():
		var button := Button.new()
		button.text = body_key.capitalize()
		button.pressed.connect(change_body.bind(body_key))
		body_row.add_child(button)
	for expression_key: String in expressions.keys():
		var button := Button.new()
		button.text = expression_key.capitalize()
		button.pressed.connect(change_expression.bind(expression_key))
		expressions_row.add_child(button)
