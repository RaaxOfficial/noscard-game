extends Card

const RECOVERY_AURA_STATUS = preload("uid://dln7276kbgh7n")

@export var recovery_aura_duration := 3

func apply_effects(targets: Array[Node], modifiers: ModifierHandler, from: Node = null) -> void:
	var status_effect := StatusEffect.new()
	var recovery_aura := RECOVERY_AURA_STATUS.duplicate()
	recovery_aura.duration = recovery_aura_duration
	recovery_aura.heal_amount = amount
	status_effect.status = recovery_aura
	status_effect.execute(targets)
