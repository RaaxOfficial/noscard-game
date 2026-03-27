extends Card


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler, _from: Node = null) -> void:
	var heal_effect := HealEffect.new()
	heal_effect.amount = amount
	heal_effect.sound = sound
	heal_effect.execute(targets)

func get_default_tooltip() -> String:
	return tooltip_text % amount
