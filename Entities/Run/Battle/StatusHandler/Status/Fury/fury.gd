class_name FuryStatus
extends Status

const ATTACK_POWER_INCREASE = preload("uid://d25nnsrt8hkls")

@export var stacks_per_turn := 1

func apply_status(target: Node) -> void:
	var status_effect := StatusEffect.new()
	var attack_power_increase := ATTACK_POWER_INCREASE.duplicate()
	attack_power_increase.stacks = stacks_per_turn
	status_effect.status = attack_power_increase
	status_effect.execute([target])
	
	status_applied.emit(self)

func get_tooltip() -> String:
	return tooltip % stacks_per_turn
