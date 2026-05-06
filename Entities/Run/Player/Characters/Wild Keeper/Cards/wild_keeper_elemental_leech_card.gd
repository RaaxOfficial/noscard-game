extends Card

const ELEMENTAL_LEECH = preload("uid://daf7v31ysqjob")

@export var duration_extend := 1


func apply_effects(targets: Array[Node], modifiers: ModifierHandler, _from: Node = null) -> void:
	var from := modifiers.get_parent()
	if from is Player and sprite_frames:
		from.play_animation(targets, sprite_frames, target)
	for each in targets:
		var status_effect := StatusEffect.new()
		var elemental_leech := ELEMENTAL_LEECH.duplicate()
		elemental_leech.duration = amount
		status_effect.status = elemental_leech
		status_effect.execute([each])
		
		var statuses: Array[Status] = each.status_handler._get_all_statuses()
		for status in statuses:
			status.duration += duration_extend
	

func get_default_tooltip() -> String:
	return tooltip_text % duration_extend

func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	return tooltip_text % duration_extend
