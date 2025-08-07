@tool
class_name FallingPlatform extends Platform

@onready var visual_root: Node2D = %VisualRoot
@onready var reappear_timer: Timer = %ReappearTimer
@onready var chunk_particles: GPUParticles2D = %ChunkParticles
@onready var player_detector: Area2D

func _ready() -> void:
	super()
	if Engine.is_editor_hint():
		return
		
	# Create player detector area
	player_detector = Area2D.new()
	player_detector.collision_layer = 0
	player_detector.collision_mask = 1  # Player layer
	add_child(player_detector)
	
	# Create shape for the detector
	var detector_shape := CollisionShape2D.new()
	detector_shape.shape = RectangleShape2D.new()
	detector_shape.shape.size = Vector2(width, 2)
	detector_shape.position = Vector2(0, -5)  # Position slightly above platform
	player_detector.add_child(detector_shape)
	
	# Connect signals
	player_detector.body_entered.connect(_on_player_detector_body_entered)
	reappear_timer.timeout.connect(_reappear_timer_timeout)
	chunk_particles.emitting = false


func _set_width(value: float) -> void:
	super(value)
	if not is_inside_tree():
		return
	
	# Update detector shape if it exists
	if player_detector and player_detector.get_child_count() > 0:
		var detector_shape := player_detector.get_child(0) as CollisionShape2D
		if detector_shape and detector_shape.shape is RectangleShape2D:
			detector_shape.shape.size.x = width
	
	chunk_particles.emitting = false


func _on_player_detector_body_entered(body: Node2D) -> void:
	if not body is Player or not body.is_on_floor():
		return
		
	# Check if player is above the platform (only trigger if player is coming from above)
	var player_pos := body.global_position
	if player_pos.y > global_position.y:
		return
		
	activate_falling_sequence()


func activate_falling_sequence() -> void:
	chunk_particles.emitting = true
	var min_width := sprite.patch_margin_left + sprite.patch_margin_right
	var tween := create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_method(func(progress: float):
		var w := maxf(min_width, width * progress)
		sprite.size.x = w
		sprite.position.x = -w/2.0
		, 1.0, 0.0, 0.6)
	tween.parallel().tween_property(visual_root, "scale", Vector2.ZERO, 0.4).set_delay(0.4)
	tween.tween_callback(func():
		visual_root.hide()
		collision_shape_2d.set_deferred("disabled", true)
		chunk_particles.emitting = false
		)
	reappear_timer.start(3.0)


func _reappear_timer_timeout() -> void:
	_set_width(width)
	visual_root.show()
	var tween := create_tween().set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(visual_root, "scale", Vector2.ONE, 0.1).from(Vector2.ONE * 0.2).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_callback(collision_shape_2d.set_deferred.bind("disabled", false))
