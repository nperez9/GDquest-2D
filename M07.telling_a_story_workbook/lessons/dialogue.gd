extends Control

@onready var text_dialog: RichTextLabel = %TextDialog
@onready var next_button: Button = %NextButton
@onready var back_button: Button = %BackButton
@onready var character_voice_sophia: AudioStreamPlayer = %CharacterVoiceSophia
@onready var character_voice_pink: AudioStreamPlayer = %CharacterVoicePink
@onready var character: TextureRect = %Character
@onready var eyes_with_a_face: TextureRect = %EyesWithAFace

var bodies := {
	"sophia": preload("res://assets/sophia.png"),
	"pink": preload("res://assets/pink.png")
}

var expressions := {
	"regular": preload("res://assets/emotion_regular.png"),
	"sad": preload("res://assets/emotion_sad.png"),
	"happy": preload("res://assets/emotion_happy.png")
}

var text_tween: Tween = null
var character_tween: Tween = null

@onready var dialogue_items: Array[Dictionary] = [
	{
		"expression": expressions["regular"],
		"text": "I've been studying [wave] arrays and dictionaries lately[/wave].",
		"character": bodies["sophia"],
		"voice": character_voice_sophia,
	},
	{
		"expression": expressions["regular"],
		"text": "Oh, nice. [i]How has it been going?[/i]",
		"character": bodies["pink"],
		"voice": character_voice_pink,
	},
	{
		"expression": expressions["sad"],
		"text": "Well... it's a [shake]little complicated![/shake]",
		"character": bodies["sophia"],
		"voice": character_voice_sophia,
	},
	{
		"expression": expressions["sad"],
		"text": "Oh!...",
		"character": bodies["pink"],
		"voice": character_voice_pink,
	},
	{
		"expression": expressions["regular"],
		"text": "[rainbow]It sure takes time to click at first.[/rainbow]",
		"character": bodies["pink"],
		"voice": character_voice_pink,
	},
	{
		"expression": expressions["happy"],
		"text": "If you keep at it, eventually, [tornado]you'll get the hang of it![/tornado]",
		"character": bodies["pink"],
		"voice": character_voice_pink,
	},
	{
		"expression": expressions["regular"],
		"text": "Mhhh... I see. [u]I'll keep at it[/u], then.",
		"character": bodies["sophia"],
		"voice": character_voice_sophia,
	},
	{
		"expression": expressions["happy"],
		"text": "Thanks for the encouragement.[wave][b] Time to LEARN!!![/b][/wave]",
		"character": bodies["sophia"],
		"voice": character_voice_sophia,
	},
]

var current_dialog_index := 0
@export var text_velocity := 0.03
@export var max_text_duration := 5.0
var sound_max_offset: float
var character_position_x := 48.0

func _ready() -> void:
	next_button.pressed.connect(next_text)
	back_button.pressed.connect(back_text)
	## max startpoint of the voice (plus 1 second, just in case) // uses pink, the shorther one
	sound_max_offset = character_voice_pink.stream.get_length() - max_text_duration
	show_text()

func show_text() -> void:
	var current_dialog := dialogue_items[current_dialog_index]
	text_dialog.text = current_dialog["text"]
	text_dialog.visible_ratio = 0
	eyes_with_a_face.texture = current_dialog["expression"]
	character.texture = current_dialog["character"]
	current_dialog["voice"].play(randf_range(0, sound_max_offset))
	## get parsed text: the text without thw tags of bbc
	var text_duration = min(text_dialog.get_parsed_text().length() * text_velocity, max_text_duration)
	print("sentence duration: ", text_duration)
	
	## animation
	if (text_tween != null):
		text_tween.kill()
	next_button.disabled = true
	back_button.disabled = true
	text_tween = create_tween()
	text_tween.tween_property(text_dialog, "visible_ratio", 1, text_duration)
	text_tween.tween_callback(func():
		current_dialog["voice"].stop()
		next_button.disabled = false
		back_button.disabled = false
	)
	slide_in()
	
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
	
func slide_in() -> void:
	var duration = 0.4
	if character_tween != null:
		character_tween.kill()
	character_tween = create_tween()
	character_tween.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	character.position.x = 250.0
	character.modulate.a = 0.0
	character_tween.set_parallel(true)
	character_tween.tween_property(character, "position:x", character_position_x, duration)
	character_tween.tween_property(character, "modulate:a", 1.0, duration)
