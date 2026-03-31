extends EnemyAction

const TEST_TOXIN = preload("uid://crnda756weadp")

@export var damage := 15

func perform_action() -> void:
	if not enemy or not target:
		return
	
	var player := target as Player
	if not player:
		return
	
	var tween := create_tween().set_trans(Tween.TRANS_QUINT)
	var start := enemy.global_position
	var end := target.global_position + Vector2.RIGHT * 32
	
	var damage_effect := DamageEffect.new()
	var target_array: Array[Node] = [target]
	var modified_damage := enemy.modifier_handler.get_modified_value(damage, Modifier.Type.DAMAGE_DEALT)
	
	damage_effect.amount = modified_damage
	damage_effect.sound = sound
	
	tween.tween_property(enemy, "global_position", end, 0.4)
	tween.tween_callback(damage_effect.execute.bind(target_array, enemy))
	tween.tween_callback(player.stats.draw_pile.add_card.bind(TEST_TOXIN.duplicate()))
	tween.tween_interval(0.25)
	tween.tween_property(enemy,"global_position", start, 0.4)
	
	SFXManager.play(sound)
	
	tween.finished.connect(
		func():
			EventManager.enemy_action_completed.emit(enemy)
	)

func update_intent_text() -> void:
	var player := target as Player
	if not player:
		return
	
	var modified_damage := player.modifier_handler.get_modified_value(damage, Modifier.Type.DAMAGE_TAKEN)
	var final_damage := enemy.modifier_handler.get_modified_value(modified_damage, Modifier.Type.DAMAGE_DEALT)
	intent.current_text = intent.base_text % final_damage
