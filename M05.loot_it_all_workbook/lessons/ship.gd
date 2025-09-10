extends Area2D

@export var health_disminution := 3
var health := 100
var gem_count := 0
var max_speed := 1200.0
var velocity := Vector2(0, 0)
var steering_factor := 3.0
var player_size := Vector2.ZERO

func _ready() -> void:
	set_health(health)
	area_entered.connect(_on_area_entered)
	%DeathTimer.timeout.connect(_on_deathtimer_timeout)
	## Smart calc to get the real sprite size
	player_size = %Sprite2D.texture.get_size() * %Sprite2D.scale / 2

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
	
	## code to appear in the other side
	var viewport_size := get_viewport_rect().size
	position.x = wrapf(position.x, 0 - player_size.x, viewport_size.x + player_size.x)
	position.y = wrapf(position.y, 0 - player_size.y, viewport_size.y + player_size.y)

	if velocity.length() > 0.0:
		%Sprite2D.rotation = velocity.angle()

func set_health(_health: int) -> void:
	health = clamp(_health, 0, 100)
	%HealthBar.value = health
	if health == 0:
		queue_free()
	
func set_gems(_gem: int) -> void:
	gem_count = _gem
	%GemLabel.text = "x" + str(gem_count)
	
func _on_area_entered(area_entered: Area2D) -> void:
	if (area_entered.is_in_group("health_pack")):
		set_health(health + 20)
	elif (area_entered.is_in_group("gem")):
		set_gems(gem_count + 1)

func _on_deathtimer_timeout() -> void:
	set_health(health - health_disminution)
