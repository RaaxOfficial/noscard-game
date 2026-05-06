extends Card

const EAGLE_SPIRIT = preload("uid://md63fk7ehunk")

@export var duration: int = 1

func apply_effects(targets: Array[Node], modifiers: ModifierHandler, _from: Node = null) -> void:
	var from := modifiers.get_parent()
	var status_effect := StatusEffect.new()
	var eagle_spirit := EAGLE_SPIRIT.duplicate()
	eagle_spirit.duration = duration
	status_effect.status = eagle_spirit
	
	if from is Player and sprite_frames:
		from.play_animation(targets, sprite_frames, target)
	
	status_effect.execute(targets)
