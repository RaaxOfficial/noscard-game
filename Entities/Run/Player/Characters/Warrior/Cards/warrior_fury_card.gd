extends Card

const FURY_STATUS = preload("uid://dtu8bbhrd4rr6")

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler, _from: Node = null) -> void:
	var status_effect := StatusEffect.new()
	var fury := FURY_STATUS.duplicate()
	status_effect.status = fury
	status_effect.execute(targets)
