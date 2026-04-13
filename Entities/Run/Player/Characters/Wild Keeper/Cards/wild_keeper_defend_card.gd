extends Card


func apply_effects(targets: Array[Node], modifiers: ModifierHandler, _from: Node = null) -> void:
	var block_effect := BlockEffect.new()
	var modified_block = modifiers.get_modified_value(amount, Modifier.Type.BLOCK_GAINED)
	block_effect.amount = modified_block
	block_effect.sound = sound
	block_effect.execute(targets)

func get_default_tooltip() -> String:
	return tooltip_text % amount

func get_updated_tooltip(player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	var modified_block = player_modifiers.get_modified_value(amount, Modifier.Type.BLOCK_GAINED)
	return tooltip_text % modified_block
