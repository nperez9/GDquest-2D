class_name Player extends CharacterBody2D


const SPEED = 300.0
const MAX_SPEED = 600.0
const ACCLERATION = 1200.0
const DEACCELERATION = 1300.0
const FIRE_RATE = 2

var can_fire := true
var current_direction: Vector2

@onready var fire_rate := %FireRate

func _ready() -> void:
	print("aaaa")
	fire_rate.wait_time = FIRE_RATE
	fire_rate.connect("timeout", func(): can_fire = true)

func _process(delta: float) -> void:
	if (Input.is_action_pressed("fire") && can_fire):
		shoot()

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move-left", "move-right", "move-up", "move-down")
	var has_input_direction := direction.length() > 0.0
	if has_input_direction:
		var desired_velocity = direction * MAX_SPEED
		velocity = velocity.move_toward(desired_velocity, ACCLERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * DEACCELERATION)
		
	move_and_slide()

## Fires a shoot
func shoot():
	print("kike fire")
	fire_rate.start()
	can_fire = false
	print_debug("FIREEEEEEE")
