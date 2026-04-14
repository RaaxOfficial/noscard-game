extends Card

const ATTACK_POWER_INCREASE = preload("uid://d25nnsrt8hkls")

@export var attack_power_stacks := 3

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler, _from: Node = null) -> void:
	var status_effect := StatusEffect.new()
	var attack_power_increase := ATTACK_POWER_INCREASE.duplicate()
	attack_power_increase.stacks = attack_power_stacks
	status_effect.status = attack_power_increase
	status_effect.execute(targets)

func get_default_tooltip() -> String:
	return tooltip_text % attack_power_stacks

func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	return tooltip_text % attack_power_stacks
