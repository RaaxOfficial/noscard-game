class_name EagleSpiritStatus
extends Status

@export var crit_chance: float
@export var crit_damage: float


var player: Player

func initialize_status(target: Node) -> void:
	if not target:
		return
	
	player = target as Player
	player.update_crit_chance(crit_chance)
	player.update_crit_damage(crit_damage)

func apply_status(target: Node) -> void:
	if not target:
		return
	
	player.update_crit_chance(crit_chance)
	player.update_crit_damage(crit_damage)
	
	status_applied.emit(self)

func get_tooltip() -> String:
	return tooltip % [int(crit_damage), int(crit_chance)]
