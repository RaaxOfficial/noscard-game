class_name EagleSpiritStatus
extends Status

@export var amount: float

func initialize_status(target: Node) -> void:
	var crit_damage_effect := CritDamageEffect.new()
	crit_damage_effect.amount = amount
	crit_damage_effect.execute([target])

func apply_status(target: Node) -> void:
	var crit_damage_effect := CritDamageEffect.new()
	crit_damage_effect.amount = amount
	crit_damage_effect.execute([target])
	
	status_applied.emit(self)

func get_tooltip() -> String:
	return tooltip % int(amount)
