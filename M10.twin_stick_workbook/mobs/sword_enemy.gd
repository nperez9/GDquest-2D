class_name SwordEnemy extends Mob

@export var rotation_speed := 8.0

const MAX_SPEED = 400.0
const ACCLERATION = 1000.0

var idle_sprite: Texture2D = preload("res://mobs/sword_inactive.png")
var active_sprite: Texture2D = preload("res://mobs/sword_active.png")

var _player: Player = null
@onready var detector: Area2D = %Detector
@onready var sprite_2d: Sprite2D = %Sprite2D

func _ready() -> void:
	detector.body_entered.connect(on_body_entered)
	detector.body_exited.connect(on_body_exited)

func _physics_process(delta: float) -> void:
	if (_player == null):
		return
	
	var direction = position.direction_to(_player.position)
	var max_speed = direction * MAX_SPEED
	velocity = velocity.move_toward(max_speed, ACCLERATION * delta)
	var target_rotation = direction.angle()
	rotation = lerp_angle(rotation, target_rotation, rotation_speed * delta)
	move_and_slide()

func on_body_entered(body) -> void:
	if body is Player:
		_player = body
		sprite_2d.texture = active_sprite

func on_body_exited(body) -> void:
	if body is Player:
		_player = null
		sprite_2d.texture = idle_sprite
		
