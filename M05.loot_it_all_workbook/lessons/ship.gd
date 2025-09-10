extends Area2D

var health := 10
var gem_count := 0
var max_speed := 1200.0
var velocity := Vector2(0, 0)
var steering_factor := 3.0

func _ready() -> void:
	set_health(health)
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	var direction := Vector2(0, 0)
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	if direction.length() > 1.0:
		direction = direction.normalized()

	var desired_velocity := max_speed * direction
	var steering := desired_velocity - velocity
	velocity += steering * steering_factor * delta
	position += velocity * delta

	if velocity.length() > 0.0:
		%Sprite2D.rotation = velocity.angle()

func set_health(_health: int) -> void:
	health = _health
	%HealthBar.value = health
	
func set_gems(_gem: int) -> void:
	gem_count = _gem
	%GemLabel.text = "x" + str(gem_count)
	
func _on_area_entered(area_entered: Area2D) -> void:
	if (area_entered.is_in_group("health_pack")):
		set_health(health + 20)
	elif (area_entered.is_in_group("gem")):
		set_gems(gem_count + 1)
