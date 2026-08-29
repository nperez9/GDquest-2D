class_name BaseLevel extends Node2D

@onready var ui_end_level: UiEndLevel = %UiEndLevel
@onready var teleporter: Teleporter = %Teleporter

var start_time: int
var end_time: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_time = Time.get_ticks_msec()
	end_time = 0
	ui_end_level.visible = false
	ui_end_level.connect_btns(play_again, quit)
	teleporter.set_win_fn(level_won)

	
func play_again() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func quit() -> void:
	get_tree().paused = false
	get_tree().quit()

func level_won() -> void:
	## TODO: add some cool animations?
	get_tree().paused = true
	end_time = Time.get_ticks_msec()
	var elapsed_time_ms = end_time - start_time
	var elapsed_seconds = snapped(elapsed_time_ms / 1000.0, 0.1)
	ui_end_level.set_time(elapsed_seconds)
	ui_end_level.visible = true
	## TODO: display some confetti
	
