extends Card

const WOLF_SPIRIT = preload("uid://bhsimd4s0l481")

@export var duration := 2


func apply_effects(targets: Array[Node], modifiers: ModifierHandler, _from: Node = null) -> void:
	var from := modifiers.get_parent()
	var status_effect = StatusEffect.new()
	var wolf_spirit = WOLF_SPIRIT.duplicate()
	wolf_spirit.duration = duration
	status_effect.status = wolf_spirit
	
	if from is Player and sprite_frames:
		from.play_animation(targets, sprite_frames, target)
	
	status_effect.execute(targets)

func get_default_tooltip() -> String:
	return tooltip_text

func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	return tooltip_text
