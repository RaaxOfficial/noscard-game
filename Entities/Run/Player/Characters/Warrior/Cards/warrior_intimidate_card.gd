extends Card

const SHOCK = preload("uid://c0tu7ov0lgrpk")

@export var duration := 2


func apply_effects(targets: Array[Node], modifiers: ModifierHandler, _from: Node = null) -> void:
	var from = modifiers.get_parent()
	if from is Player:
		from.play_animation(targets, sprite_frames, target)
	for each in targets:
		var status_effect := StatusEffect.new()
		var shock := SHOCK.duplicate()
		shock.duration = duration
		status_effect.status = shock
		status_effect.execute([each])

func get_default_tooltip() -> String:
	return tooltip_text % duration
