extends EnemyAction

const FURY = preload("uid://dtu8bbhrd4rr6")

@export var stacks_per_action := 2

var hp_threshold := 25
var usages := 0


func is_performable() -> bool:
	var hp_under_threshold := enemy.stats.health <= hp_threshold
	
	if usages == 0 or (usages == 1 and hp_under_threshold):
		usages += 1
		return true
	
	return false

func perform_action() -> void:
	if not enemy or not target:
		return
	
	var status_effect := StatusEffect.new()
	var fury := FURY.duplicate()
	fury.can_expire = true
	fury.stack_type = Status.StackType.DURATION
	fury.stacks_per_turn = stacks_per_action
	fury.duration = stacks_per_action
	status_effect.status = fury
	status_effect.execute([enemy])
	
	SFXManager.play(sound)
	
	EventManager.enemy_action_completed.emit(enemy)
