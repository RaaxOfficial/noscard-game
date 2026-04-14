class_name BearSpiritStatus
extends Status

@export var block_efficency: int

func initialize_status(target: Node) -> void:
	status_changed.connect(_on_status_changed.bind(target))
	status_applied.connect(_on_status_applied.bind(target))
	_on_status_changed(target)

func get_tooltip() -> String:
	return tooltip % block_efficency

func _on_status_changed(target: Node) -> void:
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	
	var block_gain_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.BLOCK_GAINED)
	assert(block_gain_modifier, "No block gain modifier on %s" % target)
	
	var block_modifier_value := block_gain_modifier.get_value("bear_spirit")
	
	if not block_modifier_value:
		block_modifier_value = ModifierValue.create_new_modifier("bear_spirit", ModifierValue.Type.PERCENT_BASED)
	
	block_modifier_value.percent_value = block_efficency / 100.0
	block_gain_modifier.add_new_value(block_modifier_value)

func _on_status_applied(status: Status, target: Node) -> void:
	if not status.duration <= 0:
		return
	
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	
	var block_gain_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.BLOCK_GAINED)
	assert(block_gain_modifier, "No block gain modifier on %s" % target)
	
	var block_modifier_value := block_gain_modifier.get_value("bear_spirit")
	
	if block_modifier_value:
		block_gain_modifier.remove_value(block_modifier_value.source)
