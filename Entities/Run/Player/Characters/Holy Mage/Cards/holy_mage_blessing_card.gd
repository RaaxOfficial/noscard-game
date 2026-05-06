extends Card

const BLESSING = preload("uid://bgaj72883ypav")


func apply_effects(targets: Array[Node], modifiers: ModifierHandler, _from: Node = null) -> void:
	var from := modifiers.get_parent()
	var status_effect := StatusEffect.new()
	var blessing := BLESSING.duplicate()
	status_effect.status = blessing
	
	if from is Player and sprite_frames:
		from.play_animation(targets, sprite_frames, target)
	
	status_effect.execute(targets)
