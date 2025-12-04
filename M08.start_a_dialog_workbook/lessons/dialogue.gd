extends Control

var expressions := {
	"happy": preload ("res://assets/emotion_happy.png"),
	"regular": preload ("res://assets/emotion_regular.png"),
	"sad": preload ("res://assets/emotion_sad.png"),
}

var bodies := {
	"sophia": preload ("res://assets/sophia.png"),
	"pink": preload ("res://assets/pink.png")
}

## An array of dictionaries. Each dictionary has three properties:
## - expression: a [code]Texture[/code] containing an expression
## - text: a [code]String[/code] containing the text the character says
## - character: a [code]Texture[/code] representing the character
var dialogue_items: Array[Dictionary] = [
	{
		"expression": expressions["regular"],
		"text": "[wave]Hey, wake up![/wave]\nIt's time to make video games.",
		"character": bodies["sophia"],
		"choices": {
			"Let me sleep a little longer": 2,
			"Let's do it!": 1,
		},
	},
	{
		"expression": expressions["happy"],
		"text": "Great! Your first task will be to write a [b]dialogue tree[/b].",
		"character": bodies["sophia"],
		"choices": {
			"I will do my best": 3,
			"No, let me go back to sleep": 2,
		},
	},
	{
		"expression": expressions["sad"],
		"text": "Oh, come on! It'll be fun.",
		"character": bodies["pink"],
		"choices": {
			"No, really, let me go back to sleep": 0,
			"Alright, I'll try": 1,
		},
	},
	{
		"expression": expressions["happy"],
		"text": "That's the spirit! [wave]You can do it![/wave]",
		"character": bodies["pink"],
		"choices": {"Okay! (Quit)": - 1},
	},
]

## UI element that shows the texts
@onready var rich_text_label: RichTextLabel = %RichTextLabel
## Audio player that plays voice sounds while text is being written
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
## The character
@onready var body: TextureRect = %Body
## The Expression
@onready var expression: TextureRect = %Expression
@onready var action_buttons_v_box_container: VBoxContainer = %ActionButtonsVBoxContainer


func _ready() -> void:
	show_text(0)

## Draws the current text to the rich text element
func show_text(current_item_index: int = 0) -> void:
	# We retrieve the current item from the array
	var current_item := dialogue_items[current_item_index]
	# from the item, we extract the properties.
	# We set the text to the rich text control
	# And we set the appropriate expression texture
	rich_text_label.text = current_item["text"]
	expression.texture = current_item["expression"]
	body.texture = current_item["character"]
	create_buttons(current_item["choices"])

	# We set the initial visible ratio to the text to 0, so we can change it in the tween
	rich_text_label.visible_ratio = 0.0
	# We create a tween that will draw the text
	var tween := create_tween()
	# A variable that holds the amount of time for the text to show, in seconds
	# We could write this directly in the tween call, but this is clearer.
	# We will also use this for deciding on the sound length
	var text_appearing_duration: float = current_item["text"].length() / 30.0
	# We show the text slowly
	tween.tween_property(rich_text_label, "visible_ratio", 1.0, text_appearing_duration)
	set_btns_visibility(false)
	# We randomize the audio playback's start time to make it sound different
	# every time.
	# We obtain the last possible offset in the sound that we can start from
	var sound_max_offset := audio_stream_player.stream.get_length() - text_appearing_duration
	# We pick a random position on that length
	var sound_start_position := randf() * sound_max_offset
	# We start playing the sound
	audio_stream_player.play(sound_start_position)
	# We make sure the sound stops when the text finishes displaying
	tween.tween_callback(
		func(): 
			set_btns_visibility(true)
	)
	tween.finished.connect(audio_stream_player.stop)

	# We animate the character sliding in.
	slide_in()


## Animates the character when they start talking
func slide_in() -> void:
	var slide_tween := create_tween()
	slide_tween.set_ease(Tween.EASE_OUT)
	body.position.x = get_viewport_rect().size.x / 7
	slide_tween.tween_property(body, "position:x", 0, 0.3)
	body.modulate.a = 0
	slide_tween.parallel().tween_property(body, "modulate:a", 1, 0.2)

func create_buttons(btn_dictorionary: Dictionary) -> void:
	clear_btns()
	for btn_key in btn_dictorionary:
		var button = Button.new()
		button.text = btn_key.capitalize()
		var btn_value_idx = btn_dictorionary[btn_key]
		if (btn_value_idx == -1):
			button.pressed.connect(get_tree().quit)
		else:	
			button.pressed.connect(
				func ():
					show_text(btn_dictorionary[btn_key])
			)
		action_buttons_v_box_container.add_child(button)

func clear_btns() -> void:
	for button in action_buttons_v_box_container.get_children():
			button.queue_free()
			
func set_btns_visibility(is_visible: bool):
	if !is_visible:
		for button:Button in action_buttons_v_box_container.get_children():
			button.modulate.a = 0
	elif is_visible:
		var tween = create_tween()
		for button:Button in action_buttons_v_box_container.get_children():
			tween.tween_property(button, "modulate:a", 1.0, 0.2)
