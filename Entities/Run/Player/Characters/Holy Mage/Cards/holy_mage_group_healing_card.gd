extends Card

@export var heal_amount := 1

func apply_effects(targets: Array[Node], modifiers: ModifierHandler, _from: Node = null) -> void:
	var block_effect := BlockEffect.new()
	block_effect.amount = modifiers.get_modified_value(amount, Modifier.Type.BLOCK_GAINED)
	block_effect.sound = sound
	block_effect.execute(targets)
	
	var heal_effect := HealEffect.new()
	heal_effect.amount = modifiers.get_modified_value(heal_amount, Modifier.Type.HEAL_AMOUNT)
	heal_effect.sound = sound
	heal_effect.execute(targets)

func get_default_tooltip() -> String:
	return tooltip_text % [amount, heal_amount]

func get_updated_tooltip(player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	var modified_block := player_modifiers.get_modified_value(amount, Modifier.Type.BLOCK_GAINED)
	var modified_heal := player_modifiers.get_modified_value(heal_amount, Modifier.Type.HEAL_AMOUNT) 
	
	return tooltip_text % [modified_block, modified_heal]
