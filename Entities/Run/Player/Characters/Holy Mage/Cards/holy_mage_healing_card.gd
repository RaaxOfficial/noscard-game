extends Card


func apply_effects(targets: Array[Node], modifiers: ModifierHandler, _from: Node = null) -> void:
	var from := modifiers.get_parent()
	var heal_effect := HealEffect.new()
	heal_effect.amount = modifiers.get_modified_value(amount, Modifier.Type.HEAL_AMOUNT)
	heal_effect.sound = sound
	
	if from is Player and sprite_frames:
		from.play_animation(targets, sprite_frames, target)
	
	heal_effect.execute(targets)

func get_default_tooltip() -> String:
	return tooltip_text % amount

func get_updated_tooltip(player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	var modified_amount := player_modifiers.get_modified_value(amount, Modifier.Type.HEAL_AMOUNT)
	
	return tooltip_text % modified_amount
