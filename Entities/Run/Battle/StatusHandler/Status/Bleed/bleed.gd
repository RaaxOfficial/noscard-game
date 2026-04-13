class_name BleedStatus
extends Status

func apply_status(target: Node) -> void:
	var damage_effect = DamageEffect.new()
	damage_effect.amount = stacks
	damage_effect.execute([target])
	
	status_applied.emit(self)

func get_tooltip() -> String:
	return tooltip % stacks
