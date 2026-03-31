extends Card

const COUNTER_STATUS := preload("uid://djoxk0rw6eoc1")

@export var card: Card

func apply_effects(targets: Array[Node], modifiers: ModifierHandler, _from: Node = null) -> void:
	var block_effect := BlockEffect.new()
	block_effect.amount = modifiers.get_modified_value(amount, Modifier.Type.BLOCK_GAINED)
	block_effect.sound = sound
	block_effect.execute(targets)
	
	var status_effect := StatusEffect.new()
	var counter := COUNTER_STATUS.duplicate()
	counter.card = card
	status_effect.status = counter
	status_effect.execute(targets)

func get_default_tooltip() -> String:
	return tooltip_text % amount

func get_updated_tooltip(player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	var modified_block := player_modifiers.get_modified_value(amount, Modifier.Type.BLOCK_GAINED)
	
	return tooltip_text % modified_block
