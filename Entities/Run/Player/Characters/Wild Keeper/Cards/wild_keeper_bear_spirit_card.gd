extends Card

const BEAR_SPIRIT = preload("uid://dbd50s4bgq2f7")

@export var duration := 2

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler, _from: Node = null) -> void:
	var status_effect := StatusEffect.new()
	var bear_spirit := BEAR_SPIRIT.duplicate()
	bear_spirit.duration = duration
	status_effect.status = bear_spirit
	status_effect.execute(targets)
