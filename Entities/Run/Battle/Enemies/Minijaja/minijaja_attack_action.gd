extends EnemyAction

@export var damage: int

func perform_action() -> void:
	if not enemy or not target:
		return
	
	var tween := create_tween().set_trans(Tween.TRANS_QUINT)
	var damage_effect := DamageEffect.new()
	var target_array: Array[Node] = [target]
	damage_effect.amount = damage
	damage_effect.sound = sound
	
	tween.tween_callback(enemy.action_animated_sprite.play.bind("attack"))
	tween.tween_interval(0.15)
	tween.tween_callback(damage_effect.execute.bind(target_array, enemy))
	
	tween.finished.connect(func():
		enemy.action_animated_sprite.play("idle")
		EventManager.enemy_action_completed.emit(enemy)
		)

func update_intent_text() -> void:
	var player := target as Player
	if not player:
		return
	
	var modified_damage := player.modifier_handler.get_modified_value(damage, Modifier.Type.DAMAGE_TAKEN)
	intent.current_text = intent.base_text % modified_damage
