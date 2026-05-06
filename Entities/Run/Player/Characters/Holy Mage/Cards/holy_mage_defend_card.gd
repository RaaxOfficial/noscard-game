extends Card


func apply_effects(targets: Array[Node], modifiers: ModifierHandler, _from: Node = null) -> void:
	var from := modifiers.get_parent()
	var block_effect := BlockEffect.new()
	block_effect.amount = modifiers.get_modified_value(amount, Modifier.Type.BLOCK_GAINED)
	block_effect.sound = sound
	
	if from is Player and sprite_frames:
		from.play_animation(targets, sprite_frames, target)
	
	block_effect.execute(targets)

func get_default_tooltip() -> String:
	return tooltip_text % amount

func get_updated_tooltip(player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	var modified_block := player_modifiers.get_modified_value(amount, Modifier.Type.BLOCK_GAINED)
	
	return tooltip_text % modified_block
