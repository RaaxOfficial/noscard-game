extends Card

const BLACKOUT_STATUS = preload("uid://y3cuw8vip86y")

func apply_effects(targets: Array[Node], modifiers: ModifierHandler, _from: Node = null) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(amount, Modifier.Type.DAMAGE_DEALT)
	damage_effect.sound = sound
	damage_effect.execute(targets)
	
	var status_effect := StatusEffect.new()
	var blackout := BLACKOUT_STATUS.duplicate()
	status_effect.status = blackout
	status_effect.execute(targets)
