extends Card

const RECOVERY_AURA_STATUS = preload("uid://dln7276kbgh7n")

@export var recovery_aura_duration := 3

func apply_effects(targets: Array[Node], modifiers: ModifierHandler, _from: Node = null) -> void:
	var from := modifiers.get_parent()
	var status_effect := StatusEffect.new()
	var recovery_aura := RECOVERY_AURA_STATUS.duplicate()
	recovery_aura.duration = recovery_aura_duration
	recovery_aura.heal_amount = modifiers.get_modified_value(amount, Modifier.Type.HEAL_AMOUNT)
	status_effect.status = recovery_aura
	
	if from is Player and sprite_frames:
		from.play_animation(targets, sprite_frames, target)
	
	status_effect.execute(targets)
	
	var source: StatusHandler = modifiers.get_parent().get("status_handler")
	var statuses: Array[Status] = source._get_all_statuses()
	for status in statuses:
		if status.is_debuff:
			source._remove_all_debuffs()

func get_default_tooltip() -> String:
	return tooltip_text % recovery_aura_duration
