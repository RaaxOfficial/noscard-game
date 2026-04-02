extends Card

const EAGLE_SPIRIT = preload("uid://md63fk7ehunk")

@export var duration: int = 1

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler, _from: Node = null) -> void:
	var status_effect := StatusEffect.new()
	var eagle_spirit := EAGLE_SPIRIT.duplicate()
	eagle_spirit.duration = duration
	status_effect.status = eagle_spirit
	status_effect.execute(targets)
