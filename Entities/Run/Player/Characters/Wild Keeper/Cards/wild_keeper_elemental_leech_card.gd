extends Card

const ELEMENTAL_LEECH = preload("uid://daf7v31ysqjob")

@export var duration_extend := 1


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler, _from: Node = null) -> void:
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
