extends Card

const WEAKEN_DEFENSE_POWER = preload("uid://bps5o6dkp3oyh")

@export var duration := 2


func apply_effects(targets: Array[Node], modifiers: ModifierHandler, source: Node = null) -> void:
	var from := modifiers.get_parent()
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(amount, Modifier.Type.DAMAGE_DEALT)
	damage_effect.sound = sound
	
	if from is Player and sprite_frames:
		from.play_animation(targets, sprite_frames, target)
	
	damage_effect.execute(targets, source)
	await Engine.get_main_loop().create_timer(0.2).timeout
	damage_effect.execute(targets, source)
	await Engine.get_main_loop().create_timer(0.2).timeout
	damage_effect.execute(targets, source)
	await Engine.get_main_loop().create_timer(0.2).timeout
	damage_effect.execute(targets, source)
	
	for each in targets:
		var status_effect := StatusEffect.new()
		var weaken_def_power := WEAKEN_DEFENSE_POWER.duplicate()
		weaken_def_power.duration = duration
		status_effect.status = weaken_def_power
		status_effect.execute([each])

func get_default_tooltip() -> String:
	return tooltip_text % amount

func get_updated_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var modified_damage := player_modifiers.get_modified_value(amount, Modifier.Type.DAMAGE_DEALT)
	
	if enemy_modifiers:
		modified_damage = enemy_modifiers.get_modified_value(modified_damage, Modifier.Type.DAMAGE_TAKEN)
	
	return tooltip_text % modified_damage
