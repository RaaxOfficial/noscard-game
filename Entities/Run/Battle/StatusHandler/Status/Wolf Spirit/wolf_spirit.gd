class_name CustomStatus
extends Status

@export var amount := 2

func initialize_status(target: Node) -> void:
	status_changed.connect(_on_status_changed.bind(target))
	status_applied.connect(_on_status_applied.bind(target))
	_on_status_changed(target)

func get_tooltip() -> String:
	return tooltip % amount

func _on_status_changed(target: Node) -> void:
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	
	var damage_dealt_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.DAMAGE_DEALT)
	assert(damage_dealt_modifier, "No damage dealt modifier on %s" % target)
	
	var attack_modifier_value := damage_dealt_modifier.get_value("wolf_spirit")
	
	if not attack_modifier_value:
		attack_modifier_value = ModifierValue.create_new_modifier("wolf_spirit", ModifierValue.Type.FLAT)
	
	attack_modifier_value.flat_value = amount
	damage_dealt_modifier.add_new_value(attack_modifier_value)

func _on_status_applied(status: Status, target: Node) -> void:
	if not status.id == "Wolf Spirit" and status.duration <= 0:
		return
	
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	
	var damage_dealt_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.DAMAGE_DEALT)
	assert(damage_dealt_modifier, "No damage dealt modifier on %s" % target)
	
	var attack_modifier_value := damage_dealt_modifier.get_value("wolf_spirit")
	
	if attack_modifier_value:
		damage_dealt_modifier.remove_value(attack_modifier_value.source)
