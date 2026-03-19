extends Card


func apply_effects(targets: Array[Node], sender: Node = null) -> void:
	var heal_effect := HealEffect.new()
	heal_effect.amount = amount
	heal_effect.sound = sound
	heal_effect.execute(targets)
