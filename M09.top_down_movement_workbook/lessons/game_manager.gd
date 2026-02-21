extends Node2D

@onready var _finish_line := %FinishLine
@onready var _runner: Runner = %Runner
@onready var _bouncer: CharacterBody2D = %Bouncer
@onready var _countdown: CountDown = %CountDown
@onready var _pause_menu: PauseMenu = %PauseMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_finish_line.body_entered.connect(func (body: Node) -> void:
		if body is not Runner:
			return
		
		var runner := body as Runner
		## stop physics update
		runner.set_physics_process(false)
		## force middle
		var destinitaion_pos: Vector2 = _finish_line.global_position + Vector2(0, 64)
		runner.walk_to(destinitaion_pos)
		runner.walked_to.connect(
			_finish_line.pop_confettis
		)

		_finish_line.confettis_finished.connect(
			get_tree().reload_current_scene.call_deferred
		)
	)
	
	_countdown.start_counting()
	_set_characters_physics_process(false)
	_countdown.counting_finished.connect(func(): 
		_set_characters_physics_process(true)
	)
	
	## Setup props pauseMenu
	_pause_menu.menu_opened_amount = 0.0
	_pause_menu.opening_speed = 1.0
	
func _set_characters_physics_process(enable: bool) -> void:
	_runner.set_physics_process(enable)
	_bouncer.set_physics_process(enable)
