extends Card

const BLACKOUT = preload("uid://y3cuw8vip86y")

@export var blackout_chance: float = 0.25

func apply_effects(targets: Array[Node], modifiers: ModifierHandler, _from: Node = null) -> void:
	var from = modifiers.get_parent()
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(amount, Modifier.Type.DAMAGE_DEALT)
	damage_effect.sound = sound
	
	damage_effect.execute(targets, from)
	await Engine.get_main_loop().create_timer(0.2).timeout
	damage_effect.execute(targets, from)
	
	var is_blackout := blackout_chance > randf()
	if is_blackout:
		@warning_ignore("shadowed_variable_base_class")
		for target in targets:
			if not target:
				return
			var status_effect := StatusEffect.new()
			var blackout := BLACKOUT.duplicate()
			status_effect.status = blackout
			status_effect.execute([target])

func get_default_tooltip() -> String:
	return tooltip_text % amount

func get_updated_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var modified_damage := player_modifiers.get_modified_value(amount, Modifier.Type.DAMAGE_DEALT)
	
	if enemy_modifiers:
		modified_damage = enemy_modifiers.get_modified_value(modified_damage, Modifier.Type.DAMAGE_TAKEN)
	
	return tooltip_text % modified_damage
