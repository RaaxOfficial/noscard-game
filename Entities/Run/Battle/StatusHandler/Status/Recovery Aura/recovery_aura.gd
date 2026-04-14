class_name RecoveryAuraStatus
extends Status

@export var heal_amount := 0


func apply_status(target: Node) -> void:
	var heal_effect = HealEffect.new()
	heal_effect.amount = heal_amount
	heal_effect.execute([target])
	
	status_applied.emit(self)

func get_tooltip() -> String:
	return tooltip % heal_amount
