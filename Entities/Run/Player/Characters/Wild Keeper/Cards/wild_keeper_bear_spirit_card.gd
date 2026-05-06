extends Card

const BEAR_SPIRIT = preload("uid://dbd50s4bgq2f7")

@export var duration := 2

func apply_effects(targets: Array[Node], modifiers: ModifierHandler, _from: Node = null) -> void:
	var from := modifiers.get_parent()
	var status_effect := StatusEffect.new()
	var bear_spirit := BEAR_SPIRIT.duplicate()
	bear_spirit.duration = duration
	status_effect.status = bear_spirit
	
	if from is Player and sprite_frames:
		from.play_animation(targets, sprite_frames, target)
	
	status_effect.execute(targets)
