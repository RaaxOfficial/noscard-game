extends Card

const ELEMENTAL_LEECH = preload("uid://daf7v31ysqjob")

var duration_extend := 1


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler, _from: Node = null) -> void:
	@warning_ignore("shadowed_variable_base_class")
	for target in targets:
		var status_effect := StatusEffect.new()
		var elemental_leech := ELEMENTAL_LEECH.duplicate()
		elemental_leech.duration = amount
		status_effect.status = elemental_leech
		status_effect.execute([target])
		
		var statuses: Array[Status] = target.status_handler._get_all_statuses()
		for status in statuses:
			status.duration += duration_extend
	
