extends Card


func apply_effects(targets: Array[Node], sender: Node = null) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = amount
	damage_effect.sound = sound
	
	damage_effect.execute(targets)
	await Engine.get_main_loop().create_timer(0.25).timeout
	damage_effect.execute(targets)
	await Engine.get_main_loop().create_timer(0.25).timeout
	damage_effect.execute(targets)
	await Engine.get_main_loop().create_timer(0.25).timeout
	damage_effect.execute(targets)
	
	print("TODO: Apply Cut debuff.")
