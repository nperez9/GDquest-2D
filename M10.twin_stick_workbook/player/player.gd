class_name Player extends CharacterBody2D

const SPEED = 300.0
const MAX_SPEED = 600.0
const ACCLERATION = 1200.0
const DEACCELERATION = 1300.0
const FIRE_RATE = 0.15

@export var max_health := 10
var _health: int

var can_fire := true
var current_direction: Vector2 = Vector2.DOWN

@onready var fire_rate := %FireRate
@onready var invulnerability_timer := %InvulnerabilityTimer
@onready var collision_shape := %CollisionShape2D
@onready var health_bar := %HealthBar

@onready var sprite := %Sprite
@onready var weapon_pivot := %WeaponPivot
@onready var weapon := %Weapon
var bullet = preload("res://weapons/bullet.tscn")

func _ready() -> void:
	health_bar.max_value = max_health
	_modify_health(max_health)
	fire_rate.wait_time = FIRE_RATE
	fire_rate.connect("timeout", func(): can_fire = true)
	invulnerability_timer.connect("timeout", func(): _invulnerability_time(false))
	toggle_player_control(true)

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move-left", "move-right", "move-up", "move-down")
	var has_input_direction := direction.length() > 0.0
	if has_input_direction:
		current_direction = direction
		var desired_velocity = direction * MAX_SPEED
		velocity = velocity.move_toward(desired_velocity, ACCLERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * DEACCELERATION)
		
	##if (Input.is_action_pressed("fire") && can_fire):
		##shoot()
	move_and_slide()
	
func _modify_health(new_health: int) -> void:
	_health = new_health
	health_bar.value = new_health
	
func take_damage(damage: int) -> void:
	var new_health := clampi(_health - damage, 0, max_health)
	_modify_health(new_health)
	if _health <= 0:
		die()
	else:
		_invulnerability_time(true)
		invulnerability_timer.start()
	
func _invulnerability_time(is_on: bool):
	collision_shape.disabled = is_on
	var alpha = 0.5 if is_on else 1.0
	sprite.modulate.a = alpha
	weapon_pivot.modulate.a = alpha
		
func toggle_player_control(is_active: bool) -> void:
	set_physics_process(is_active)
	sprite.set_process(is_active)
	weapon_pivot.set_process(is_active)
	weapon.set_physics_process(is_active)

func die() -> void:
	toggle_player_control(false)
	print("shinde")
	
func heal(heal_amount: int) -> void:
	_modify_health(clampi(heal_amount + _health, 0, max_health)) 
