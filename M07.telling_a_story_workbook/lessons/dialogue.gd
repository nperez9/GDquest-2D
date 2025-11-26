extends Control

@onready var text_dialog: RichTextLabel = %TextDialog
@onready var next_button: Button = %NextButton
@onready var back_button: Button = %BackButton
@onready var character_voice: AudioStreamPlayer = %CharacterVoice

var dialogue_items: Array[String] = [
	"Hi! I'm the first line of dialogue.",
	"I'm the second line.",
	"And I am the third!",
	"Finally, I'm the last line. Bye!"
]
var current_dialog_index := 0
@export var text_velocity := 0.05
@export var max_text_duration := 5.0
var sound_max_offset: float

func _ready() -> void:
	next_button.pressed.connect(next_text)
	back_button.pressed.connect(back_text)
	## max startpoint of the voice (plus 1 second, just in case)
	sound_max_offset = character_voice.stream.get_length() - max_text_duration
	show_text()

func show_text() -> void:
	var current_dialog := dialogue_items[current_dialog_index]
	text_dialog.text = current_dialog
	text_dialog.visible_ratio = 0
	character_voice.play(randf_range(0, sound_max_offset))
	var text_duration = min(current_dialog.length() * text_velocity, max_text_duration)
	print(text_duration)
	## animation
	var tween = create_tween()
	tween.tween_property(text_dialog, "visible_ratio", 1, text_duration)
	tween.tween_callback(func():
		character_voice.stop()
	)
	
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
