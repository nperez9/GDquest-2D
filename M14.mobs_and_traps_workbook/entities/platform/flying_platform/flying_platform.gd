@tool
extends Platform

@onready var right_wing: AnimatedSprite2D = %RightWing
@onready var left_wing: AnimatedSprite2D = %LeftWing
@onready var sparkling_particles: GPUParticles2D = %SparklingParticles

@export var platform_speed := 16.0
@export var back_and_forth := true
@export var trans_type: Tween.TransitionType = Tween.TRANS_SINE

var curve_length := 1.0
var path: Path2D


func _set_width(value: float) -> void:
	super(value)
	if not is_inside_tree():
		return
	var half_width := (width / 2.0) - 1
	right_wing.position.x = half_width
	left_wing.position.x = -half_width
	sparkling_particles.process_material.set("emission_box_extents:x", half_width)


func _ready() -> void:
	super()
	set_process(not Engine.is_editor_hint())
	if Engine.is_editor_hint():
		return
	path = get_parent() as Path2D
	if path == null && path.curve == null:
		return
	_interpolate_position(0.0)
	curve_length = path.curve.get_baked_length()
	var duration := curve_length / platform_speed
	var tween := create_tween().set_loops(0).set_process_mode(Tween.TWEEN_PROCESS_PHYSICS).set_trans(trans_type)
	tween.tween_method(_interpolate_position, 0.0, 1.0, duration)
	if back_and_forth:
		tween.tween_method(_interpolate_position, 1.0, 0.0, duration)


func _interpolate_position(offset: float) -> void:
	var p := path.curve.sample_baked(offset * curve_length)
	p.y += sin(offset * TAU) * 16.0
	position = p
