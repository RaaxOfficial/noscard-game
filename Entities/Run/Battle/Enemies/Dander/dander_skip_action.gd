extends EnemyAction

func is_performable() -> bool:
	if not enemy or not target:
		return false
	
	return enemy.stats.stunned

func perform_action() -> void:
	if not enemy or not target:
		return
	
	var tween := create_tween()
	tween.tween_callback(ShakeManager.shake.bind(enemy, 16, 0.15))
	SFXManager.play(sound)
	tween.tween_interval(0.17)
	
	tween.finished.connect(
		func():
			EventManager.enemy_action_completed.emit(enemy)
	)
	
