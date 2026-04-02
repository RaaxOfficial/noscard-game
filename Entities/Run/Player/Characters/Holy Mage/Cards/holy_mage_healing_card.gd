extends Card


func apply_effects(targets: Array[Node], modifiers: ModifierHandler, _from: Node = null) -> void:
	var heal_effect := HealEffect.new()
	heal_effect.amount = modifiers.get_modified_value(amount, Modifier.Type.HEAL_AMOUNT)
	heal_effect.sound = sound
	heal_effect.execute(targets)

func get_default_tooltip() -> String:
	return tooltip_text % amount
