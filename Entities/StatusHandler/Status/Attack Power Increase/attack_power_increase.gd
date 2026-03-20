class_name AttackPowerIncreaseStatus
extends Status


func initialize_status(target: Node) -> void:
	status_changed.connect(_on_status_changed.bind(target))
	_on_status_changed(target)

func _on_status_changed(target: Node) -> void:
	# If the condition (first argument) is false, generate error with message (second argument).
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	
	var damage_dealt_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.DAMAGE_DEALT)
	assert(damage_dealt_modifier, "No damage dealt modifier on %s" % target)
	
	var attack_modifier_value := damage_dealt_modifier.get_value("fury")
	
	if not attack_modifier_value:
		attack_modifier_value = ModifierValue.create_new_modifier("fury", ModifierValue.Type.FLAT)
	
	attack_modifier_value.flat_value = stacks
	damage_dealt_modifier.add_new_value(attack_modifier_value)
