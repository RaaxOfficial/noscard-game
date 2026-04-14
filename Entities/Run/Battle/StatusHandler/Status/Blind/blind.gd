class_name BlindStatus
extends Status

const MODIFIER := 0.5

var initial_accuracy: float

func initialize_status(target: Node) -> void:
	if not target:
		return
	
	initial_accuracy = target.stats.accuracy
	target.stats.accuracy = MODIFIER
	
	status_applied.connect(_on_status_applied.bind(target))

func apply_status(target: Node) -> void:
	if not target:
		return
	
	target.stats.accuracy = MODIFIER
	
	status_applied.emit(self)

func _on_status_applied(status: Status, target: Node) -> void:
	if not status or duration >= 1:
		return
	
	target.stats.accuracy = initial_accuracy
