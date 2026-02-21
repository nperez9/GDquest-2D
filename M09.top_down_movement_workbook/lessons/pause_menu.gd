## Main Pause menu
## Emit signals when the buttons are clicked, tool is for seeing it in the editor preview
@tool
class_name PauseMenu extends Control

@export_range(0, 1.0) var menu_opened_amount := 0.0:
	set = set_menu_opened_amount

@export_range(0, 5.0, 0.1, "or_greater") var opening_speed := 1.0

@onready var _color_rect: ColorRect = %ColorRect
@onready var _panel_container: PanelContainer = %PanelContainer

@onready var _resume_btn: Button = %Resume
@onready var _quit_btn: Button = %Quit

var _tween: Tween
var _is_currently_opening = false

signal resume
signal quit

## final value of the bg blur, alo more shader stuff
const BLUR_SHADER_BLUR_AMOUNT := 4.0
const BLUR_SHADER_SATURATION := 0.4
const BLUR_SHADER_TINT_STR := 0.2
const BLUR_SHADER_TINT := "4f52bf"

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	_resume_btn.pressed.connect(toggle)
	_quit_btn.pressed.connect(get_tree().quit)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle()

func toggle() -> void:
	_is_currently_opening = not _is_currently_opening
	if _is_currently_opening:
		get_tree().paused = true
	var duration := opening_speed
	
	if _tween != null:
		if not _is_currently_opening:
			duration = _tween.get_total_elapsed_time()
		_tween.kill()
	
	## var variable = value1 if condition else value2
	var target_amount := 1.0 if _is_currently_opening else 0.0
	_tween = create_tween()
	_tween.set_ease(Tween.EASE_OUT)
	_tween.set_trans(Tween.TRANS_QUART)
	
	_tween.tween_property(self, "menu_opened_amount", target_amount, duration)
	_tween.tween_callback(func():
		if !_is_currently_opening:
			get_tree().paused = false
	)

## When is zero, removes visible, which is not clickeable
func set_menu_opened_amount(amount: float) -> void:
	## Setters can be called before onReady, so: 
	# final stuff
	menu_opened_amount = amount
	visible = amount > 0
	if _color_rect == null || _panel_container == null:
		return

	#shader manipulation
	var current_blur = lerp(0.0, BLUR_SHADER_BLUR_AMOUNT, amount)
	var current_saturaion = lerp(1.0, BLUR_SHADER_SATURATION, amount)
	var current_tint_str = lerp(0.0, BLUR_SHADER_TINT_STR, amount)
	_color_rect.material.set_shader_parameter("blur_amount", current_blur)
	_color_rect.material.set_shader_parameter("saturation", current_saturaion)
	_color_rect.material.set_shader_parameter("tint_strength", current_tint_str)
	# panel anim
	_panel_container.modulate.a = amount
