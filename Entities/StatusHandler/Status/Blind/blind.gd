class_name BlindStatus
extends Status

const MODIFIER := 0.5


func apply_status(target: Node) -> void:
	print("%s should decrease %s%% accuracy" % [target, MODIFIER * 100])
	
	status_applied.emit(self)
