extends Card

const FURY_STATUS = preload("uid://dtu8bbhrd4rr6")

func apply_effects(targets: Array[Node], modifiers: ModifierHandler, _from: Node = null) -> void:
	var from = modifiers.get_parent()
	var status_effect := StatusEffect.new()
	var fury := FURY_STATUS.duplicate()
	status_effect.status = fury
	
	if from is Player and sprite_frames:
		from.play_animation(targets, sprite_frames, target)
	
	status_effect.execute(targets)
