extends Card

const WEAKEN_DEF_POWER_STATUS = preload("uid://bps5o6dkp3oyh")

@export var override_duration := 2

func apply_effects(targets: Array[Node], modifiers: ModifierHandler, from: Node = null) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(amount, Modifier.Type.DAMAGE_DEALT)
	damage_effect.sound = sound
	damage_effect.execute(targets)
	
	var status_effect := StatusEffect.new()
	var weaken_defense_power := WEAKEN_DEF_POWER_STATUS.duplicate()
	weaken_defense_power.duration = override_duration
	status_effect.status = weaken_defense_power
	status_effect.execute(targets)
	
