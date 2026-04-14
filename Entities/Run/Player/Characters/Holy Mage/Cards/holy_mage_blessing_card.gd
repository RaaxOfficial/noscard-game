extends Card

const BLESSING = preload("uid://bgaj72883ypav")


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler, _from: Node = null) -> void:
	var status_effect := StatusEffect.new()
	var blessing := BLESSING.duplicate()
	status_effect.status = blessing
	status_effect.execute(targets)
