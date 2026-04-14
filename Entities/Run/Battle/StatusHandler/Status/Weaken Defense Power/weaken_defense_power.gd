class_name WeakenDefensePowerStatus
extends Status

@export var modifier_amount := 0.3

func initialize_status(target: Node) -> void:
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	
	var damage_taken_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.DAMAGE_TAKEN)
	assert(damage_taken_modifier, "No dmg taken modif on %s" % target)
	
	var weaken_def_power_modifier_value := damage_taken_modifier.get_value("weaken_defense_power")
	
	if not weaken_def_power_modifier_value:
		weaken_def_power_modifier_value = ModifierValue.create_new_modifier("weaken_defense_power", ModifierValue.Type.PERCENT_BASED)
		weaken_def_power_modifier_value.percent_value = modifier_amount
		damage_taken_modifier.add_new_value(weaken_def_power_modifier_value)
	
	if not status_changed.is_connected(_on_status_changed):
		status_changed.connect(_on_status_changed.bind(damage_taken_modifier))

func _on_status_changed(damage_taken_modifier: Modifier) -> void:
	if duration <= 0 and damage_taken_modifier:
		damage_taken_modifier.remove_value("weaken_defense_power")
