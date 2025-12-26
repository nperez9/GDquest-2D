## Main Pause menu
## Emit signals when the buttons are clicked
class_name PauseMenu extends Control

@export var menu_opened := 0.8
@export var opening_speed := 2.3

@onready var _color_rect: ColorRect = %ColorRect
@onready var _panel_container: PanelContainer = %PanelContainer

@onready var _resume_btn: Button = %Resume
@onready var _quit_btn: Button = %Quit

signal resume
signal quit

func _ready() -> void:
	_resume_btn.pressed.connect(func():
		resume.emit()
	)
	
	_quit_btn.pressed.connect(func():
		quit.emit()
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
