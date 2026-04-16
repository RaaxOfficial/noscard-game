class_name ShockStatus
extends Status

@export var skip_chance: float = 0.5

func apply_status(target: Node) -> void:
	var skip = skip_chance > randf()
	
	if skip:
		target.skip_turn()
	
	status_applied.emit(self)

func get_tooltip() -> String:
	return tooltip % int(skip_chance * 100)
