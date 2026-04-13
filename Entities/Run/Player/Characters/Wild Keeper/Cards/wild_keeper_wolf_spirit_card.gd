extends Card

const WOLF_SPIRIT = preload("uid://bhsimd4s0l481")

@export var duration := 2


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler, _from: Node = null) -> void:
	var status_effect = StatusEffect.new()
	var wolf_spirit = WOLF_SPIRIT.duplicate()
	wolf_spirit.duration = duration
	status_effect.status = wolf_spirit
	status_effect.execute(targets)

func get_default_tooltip() -> String:
	return tooltip_text

func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	return tooltip_text
