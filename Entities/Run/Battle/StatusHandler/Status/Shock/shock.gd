class_name ShockStatus
extends Status

var skip_chance: float = 0.5

func apply_status(target: Node) -> void:
	var skip = skip_chance > randf()
	
	if skip:
		target.skip_turn()
	
	status_applied.emit(self)
