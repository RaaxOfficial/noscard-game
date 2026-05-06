extends EnemyAction

@export var damage: int

func perform_action() -> void:
	if not enemy or not target:
		return
	
	var tween := create_tween().set_trans(Tween.TRANS_QUINT)
	var start := enemy.global_position
	var end := target.global_position + Vector2.RIGHT * 32
	var damage_effect := DamageEffect.new()
	var target_array: Array[Node] = [target]
	damage_effect.amount = enemy.modifier_handler.get_modified_value(damage, Modifier.Type.DAMAGE_DEALT)
	damage_effect.sound = sound
	
	tween.tween_property(enemy, "global_position", end, 0.4)
	tween.tween_callback(enemy.action_animated_sprite.play.bind("attack"))
	tween.tween_interval(0.15)
	tween.tween_callback(damage_effect.execute.bind(target_array, enemy))
	tween.tween_interval(0.3)
	tween.tween_property(enemy, "global_position", start, 0.4)
	
	tween.finished.connect(func():
		enemy.action_animated_sprite.play("idle")
		EventManager.enemy_action_completed.emit(enemy)
		)

func update_intent_text() -> void:
	if not enemy:
		return
	
	var modified_damage := enemy.modifier_handler.get_modified_value(damage, Modifier.Type.DAMAGE_DEALT)
	intent.current_text = intent.base_text % modified_damage
