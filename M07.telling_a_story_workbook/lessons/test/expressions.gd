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
@onready var button_sofia: Button = %ButtonSofia
@onready var button_pink: Button = %ButtonPink
@onready var button_regular: Button = %ButtonRegular
@onready var button_happy: Button = %ButtonHappy
@onready var button_sad: Button = %ButtonSad

var current_state := {
	"body": null,
	"expression": null
}

func _ready() -> void:
	character.texture = bodies["sofia"]
	eyes_with_a_face.texture = expressions["regular"]
	
	button_sofia.pressed.connect(change_body.bind("sofia"))
	button_pink.pressed.connect(change_body.bind("pink"))
	
	button_regular.pressed.connect(change_expression.bind("regular"))
	button_happy.pressed.connect(change_expression.bind("happy"))
	button_sad.pressed.connect(change_expression.bind("sad"))

func change_body(body_key: String) -> void:
	character.texture = bodies[body_key]

func change_expression(expression_key: String) -> void:
	eyes_with_a_face.texture = expressions[expression_key]
