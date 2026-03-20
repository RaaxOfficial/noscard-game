extends Card


func apply_effects(targets: Array[Node], modifiers: ModifierHandler, from: Node = null) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = amount
	damage_effect.sound = sound
	damage_effect.execute(targets)
	
	print("TODO: Apply Weaken Attack Power debuff.")
