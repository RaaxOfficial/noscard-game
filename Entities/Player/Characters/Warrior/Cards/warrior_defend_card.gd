extends Card

const COUNTER_STATUS := preload("uid://djoxk0rw6eoc1")

@export var card: Card

func apply_effects(targets: Array[Node], from: Node = null) -> void:
	var block_effect := BlockEffect.new()
	block_effect.amount = amount
	block_effect.sound = sound
	block_effect.execute(targets)
	
	var status_effect := StatusEffect.new()
	var counter := COUNTER_STATUS.duplicate()
	counter.card = card
	status_effect.status = counter
	status_effect.execute(targets)
