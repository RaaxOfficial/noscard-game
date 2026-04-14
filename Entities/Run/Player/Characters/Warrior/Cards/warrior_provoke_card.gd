extends Card

const COUNTER = preload("uid://djoxk0rw6eoc1")

@export var counter_card: Card


func apply_effects(targets: Array[Node], modifiers: ModifierHandler, _from: Node = null) -> void:
	var source := modifiers.get_parent()
	var block_effect := BlockEffect.new()
	var modified_block = modifiers.get_modified_value(amount, Modifier.Type.BLOCK_GAINED)
	block_effect.amount = modified_block
	block_effect.sound = sound
	block_effect.execute([source])
	
	for each in targets:
		var status_effect := StatusEffect.new()
		var counter := COUNTER.duplicate()
		counter.card = counter_card
		status_effect.status = counter
		status_effect.execute([source])

func get_default_tooltip() -> String:
	return tooltip_text % amount

func get_updated_tooltip(player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	var modified_block = player_modifiers.get_modified_value(amount, Modifier.Type.BLOCK_GAINED)
	return tooltip_text % modified_block
