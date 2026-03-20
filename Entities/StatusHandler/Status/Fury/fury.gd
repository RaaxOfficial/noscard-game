class_name FuryStatus
extends Status

const ATTACK_POWER_INCREASE_STATUS = preload("uid://d25nnsrt8hkls")

func apply_status(target: Node) -> void:
	var status_effect := StatusEffect.new()
	var attack_power_increase := ATTACK_POWER_INCREASE_STATUS.duplicate()
	status_effect.status = attack_power_increase
	status_effect.execute([target])
