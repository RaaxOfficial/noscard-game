class_name ElementalLeechStatus
extends Status

@export var crit_chance := 0.15

func initialize_status(target: Node) -> void:
	print("Initialize my status for target %s" % target)

func apply_status(target: Node) -> void:
	print("My status target %s" % target)
	
	status_applied.emit(self)

func get_tooltip() -> String:
	var formatted_crit := int(crit_chance * 100)
	return tooltip % formatted_crit
