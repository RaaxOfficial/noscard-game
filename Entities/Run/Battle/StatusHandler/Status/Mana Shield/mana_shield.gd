class_name ManaShieldStatus
extends Status

@export var hp_threshold: int

func initialize_status(target: Node) -> void:
	EventManager.player_hurt.connect(_on_player_hurt.bind(target))

func get_tooltip() -> String:
	return tooltip % hp_threshold

func _on_player_hurt(health_lost: int, target: Node) -> void:
	if not target:
		return
	
	var player := target as Player
	
	if health_lost >= hp_threshold:
		player.stats.heal(health_lost - 1)
		status_applied.emit(self)
