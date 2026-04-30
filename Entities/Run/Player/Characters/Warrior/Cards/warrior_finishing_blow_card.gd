extends Card

const WEAKEN_DEFENSE_POWER = preload("uid://bps5o6dkp3oyh")

@export var duration := 1

func apply_effects(targets: Array[Node], modifiers: ModifierHandler, _from: Node = null) -> void:
	var from = modifiers.get_parent()
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(amount, Modifier.Type.DAMAGE_DEALT)
	damage_effect.sound = sound
	
	if from is Player:
		from.attack_anim_sprite.sprite_frames = sprite_frames
		from.play_attack_animation(targets)
	
	damage_effect.execute(targets, from)
	
	var status_effect := StatusEffect.new()
	var weaken_def_power := WEAKEN_DEFENSE_POWER.duplicate()
	weaken_def_power.duration = duration
	status_effect.status = weaken_def_power
	status_effect.execute(targets)

func get_default_tooltip() -> String:
	return tooltip_text % [amount, duration]

func get_updated_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var modified_damage := player_modifiers.get_modified_value(amount, Modifier.Type.DAMAGE_DEALT)
	
	if enemy_modifiers:
		modified_damage = enemy_modifiers.get_modified_value(modified_damage, Modifier.Type.DAMAGE_TAKEN)
	
	return tooltip_text % [modified_damage, duration]
