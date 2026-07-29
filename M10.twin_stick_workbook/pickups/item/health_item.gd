class_name HealthItem extends Item

@export var heal_power := 5

func use(player: Player) -> void:
	player.heal(heal_power)
