class_name UiEndLevel extends CanvasLayer

@onready var time: Label = %Time
@onready var play_again: Button = %"Play again"
@onready var quit: Button = %Quit

var template = "Time: %s s"

func _ready() -> void:
	time.text = template
	## Small guard to prevent the menu to freezes
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func connect_btns(replay_fn: Callable, quit_fn: Callable) -> void:
	play_again.connect("button_down", replay_fn)
	quit.connect("button_down", quit_fn)

func set_time(formatted_time: float) -> void:
	time.text = template % formatted_time
