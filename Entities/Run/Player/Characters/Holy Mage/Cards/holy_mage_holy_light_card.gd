extends Card

const BLIND_STATUS = preload("uid://dh0t1hba5vo5v")

@export var blind_duration := 2

func apply_effects(targets: Array[Node], modifiers: ModifierHandler, _from: Node = null) -> void:
	var from = modifiers.get_parent()
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(amount, Modifier.Type.DAMAGE_DEALT)
	damage_effect.sound = sound
	
	if from is Player and sprite_frames:
		from.play_animation(targets, sprite_frames, target)
	
	damage_effect.execute(targets, from)
	
	var status_effect := StatusEffect.new()
	var blind := BLIND_STATUS.duplicate()
	blind.duration = blind_duration
	status_effect.status = blind
	status_effect.execute(targets)

func get_default_tooltip() -> String:
	return tooltip_text % [amount, blind_duration]

func get_updated_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var modified_damage := player_modifiers.get_modified_value(amount, Modifier.Type.DAMAGE_DEALT)
	
	if enemy_modifiers:
		modified_damage = enemy_modifiers.get_modified_value(modified_damage, Modifier.Type.DAMAGE_TAKEN)
	
	return tooltip_text % [modified_damage, blind_duration]
