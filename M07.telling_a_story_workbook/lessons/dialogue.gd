extends Control

@onready var text_dialog: RichTextLabel = %TextDialog
@onready var next_button: Button = %NextButton
@onready var back_button: Button = %BackButton

var dialogue_items: Array[String] = [
	"Hi! I'm the first line of dialogue.",
	"I'm the second line.",
	"And I am the third!",
	"Finally, I'm the last line. Bye!"
]
var current_dialog_index := 0

func _ready() -> void:
	next_button.pressed.connect(next_text)
	back_button.pressed.connect(back_text)
	show_text()

func show_text() -> void:
	var current_dialog := dialogue_items[current_dialog_index]
	text_dialog.text = current_dialog
	
func next_text() -> void:
	if (current_dialog_index >= dialogue_items.size() - 1):
		current_dialog_index = 0
	else:
		current_dialog_index += 1
	show_text()

func back_text() -> void:
	current_dialog_index -= 1
	if (current_dialog_index < 0):
		current_dialog_index = 0
	show_text()
