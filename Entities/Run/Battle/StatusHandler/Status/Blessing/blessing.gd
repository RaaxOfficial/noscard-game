class_name BlessingStatus
extends Status

@export var block_efficency: int

func initialize_status(target: Node) -> void:
	apply_status(target)

func apply_status(target: Node) -> void:
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	
	var block_gain_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.BLOCK_GAINED)
	assert(block_gain_modifier, "No block gain modifier on %s" % target)
	
	var block_modifier_value := block_gain_modifier.get_value("blessing")
	
	if not block_modifier_value:
		block_modifier_value = ModifierValue.create_new_modifier("blessing", ModifierValue.Type.PERCENT_BASED)
	
	block_modifier_value.percent_value = block_efficency / 100.0
	block_gain_modifier.add_new_value(block_modifier_value)

func get_tooltip() -> String:
	return tooltip % block_efficency
