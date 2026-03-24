extends Card


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler, _from: Node = null) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = amount
	damage_effect.sound = sound
	
	damage_effect.execute(targets)
	await Engine.get_main_loop().create_timer(0.25).timeout
	damage_effect.execute(targets)
	
	print("TODO: Apply Blackout debuff with 25% chance.")

func get_default_tooltip() -> String:
	return tooltip_text % amount

func get_updated_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var modified_damage := player_modifiers.get_modified_value(amount, Modifier.Type.DAMAGE_DEALT)
	
	if enemy_modifiers:
		modified_damage = enemy_modifiers.get_modified_value(modified_damage, Modifier.Type.DAMAGE_TAKEN)
	
	return tooltip_text % modified_damage
