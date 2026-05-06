extends Card

const WEAKEN_ATTACK_POWER = preload("uid://bew6xrjxi55hq")

@export var duration := 1

func apply_effects(targets: Array[Node], modifiers: ModifierHandler, _from: Node = null) -> void:
	var from = modifiers.get_parent()
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(amount, Modifier.Type.DAMAGE_DEALT)
	damage_effect.sound = sound
	
	if from is Player and sprite_frames:
		from.play_animation(targets, sprite_frames, target)
	
	damage_effect.execute(targets, from)
	
	for each in targets:
		var status_effect := StatusEffect.new()
		var weaken_atk_power := WEAKEN_ATTACK_POWER.duplicate()
		weaken_atk_power.duration = duration
		status_effect.status = weaken_atk_power
		status_effect.execute([each])

func get_default_tooltip() -> String:
	return tooltip_text % [amount, duration]

func get_updated_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var modified_damage := player_modifiers.get_modified_value(amount, Modifier.Type.DAMAGE_DEALT)
	
	if enemy_modifiers:
		modified_damage = enemy_modifiers.get_modified_value(modified_damage, Modifier.Type.DAMAGE_TAKEN)
	
	return tooltip_text % [modified_damage, duration]
