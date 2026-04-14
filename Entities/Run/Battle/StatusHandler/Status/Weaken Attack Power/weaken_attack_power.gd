class_name WeakenAttackPowerStatus
extends Status

@export var modifier_amount := 0.3

func initialize_status(target: Node) -> void:
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	
	var damage_dealt_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.DAMAGE_DEALT)
	assert(damage_dealt_modifier, "No dmg taken modif on %s" % target)
	
	var weaken_atk_power_modifier_value := damage_dealt_modifier.get_value("weaken_attack_power")
	
	if not weaken_atk_power_modifier_value:
		weaken_atk_power_modifier_value = ModifierValue.create_new_modifier("weaken_attack_power", ModifierValue.Type.PERCENT_BASED)
		weaken_atk_power_modifier_value.percent_value = -modifier_amount
		damage_dealt_modifier.add_new_value(weaken_atk_power_modifier_value)
	
	if not status_changed.is_connected(_on_status_changed):
		status_changed.connect(_on_status_changed.bind(damage_dealt_modifier))

func _on_status_changed(damage_dealt_modifier: Modifier) -> void:
	if duration <= 0 and damage_dealt_modifier:
		damage_dealt_modifier.remove_value("weaken_attack_power")
