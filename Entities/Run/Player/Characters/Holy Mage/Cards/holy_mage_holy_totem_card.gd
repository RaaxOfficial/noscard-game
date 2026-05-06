extends Card

@export var damage: int

func apply_effects(targets: Array[Node], modifiers: ModifierHandler, _from: Node = null) -> void:
	var from := modifiers.get_parent()
	var block_effect := BlockEffect.new()
	block_effect.amount = modifiers.get_modified_value(amount, Modifier.Type.BLOCK_GAINED)
	block_effect.sound = sound
	
	if from is Player and sprite_frames:
		from.play_animation(targets, sprite_frames, target)
	
	block_effect.execute(targets)

func get_default_tooltip() -> String:
	return tooltip_text % [amount, damage]

func get_updated_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var modified_block := player_modifiers.get_modified_value(amount, Modifier.Type.BLOCK_GAINED)
	var modified_damage := player_modifiers.get_modified_value(damage, Modifier.Type.DAMAGE_DEALT)
	modified_damage = enemy_modifiers.get_modified_value(modified_damage, Modifier.Type.DAMAGE_TAKEN)
	
	return tooltip_text % [modified_block, modified_damage]
