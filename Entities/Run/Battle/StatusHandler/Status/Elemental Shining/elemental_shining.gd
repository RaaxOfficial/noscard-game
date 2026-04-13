class_name ElementalShiningStatus
extends Status

@export var amount: float = 0.0

var player: Player

func initialize_status(target: Node) -> void:
	status_applied.connect(_on_status_applied)
	
	if not target:
		return
	
	player = target as Player
	player.stats.dodge = amount

func apply_status(target: Node) -> void:
	if not target:
		return
	
	player.stats.dodge = amount
	
	status_applied.emit(self)

func get_tooltip() -> String:
	return tooltip % int(amount)

func _on_status_applied(status: Status) -> void:
	if status.duration <= 0:
		player.stats.reset_dodge()
