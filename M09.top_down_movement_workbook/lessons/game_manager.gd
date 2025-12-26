extends Node2D

@onready var _finish_line := %FinishLine
@onready var _runner: Runner = %Runner
@onready var _countdown: CountDown = %CountDown

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
	_runner.set_physics_process(false)
	_countdown.counting_finished.connect(func(): 
		_runner.set_physics_process(true)	
	)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
