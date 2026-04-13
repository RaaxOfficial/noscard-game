extends Card

const BLEED = preload("uid://grt8ldamp306")

@export var stacks := 1

func apply_effects(targets: Array[Node], modifiers: ModifierHandler, _from: Node = null) -> void:
	var source = modifiers.get_parent()
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(amount, Modifier.Type.DAMAGE_DEALT)
	damage_effect.sound = sound
	damage_effect.execute(targets, source)
	await Engine.get_main_loop().create_timer(0.2).timeout
	damage_effect.execute(targets, source)
	
	var status_effect := StatusEffect.new()
	var bleed := BLEED.duplicate()
	bleed.stacks = stacks
	bleed.duration = stacks
	status_effect.status = bleed
	status_effect.execute(targets)

func get_default_tooltip() -> String:
	return tooltip_text % [amount, stacks]

func get_updated_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var modified_damage := player_modifiers.get_modified_value(amount, Modifier.Type.DAMAGE_DEALT)
	
	if enemy_modifiers:
		modified_damage = enemy_modifiers.get_modified_value(modified_damage, Modifier.Type.DAMAGE_TAKEN)
	
	return tooltip_text % [modified_damage, stacks]
