class_name BlackoutStatus
extends Status


func initialize_status(target: Node) -> void:
	if target is not Enemy:
		return
	
	target.skip_turn()

func apply_status(_target: Node) -> void:
	status_applied.emit(self)
