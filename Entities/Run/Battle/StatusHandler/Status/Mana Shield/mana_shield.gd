class_name ManaShieldStatus
extends Status

@export var hp_threshold: int

func initialize_status(target: Node) -> void:
	print("Initialize my status for target %s" % target)

func apply_status(target: Node) -> void:
	print("My status target %s" % target)
	
	status_applied.emit(self)

func get_tooltip() -> String:
	return tooltip % hp_threshold
