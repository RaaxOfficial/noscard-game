class_name CounterStatus
extends Status

@export var card: Card
var player_hit := false
var enemy: Enemy

func initialize_status(_target: Node) -> void:
	EventManager.player_hit.connect(_on_player_hit)
	EventManager.enemy_action_completed.connect(_on_enemy_action_completed)

func apply_status(target: Node) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = card.amount
	damage_effect.sound = card.sound
	damage_effect.execute([target])
	stacks -= 1
	player_hit = false
	enemy = null
	
	status_applied.emit(self)

func get_tooltip() -> String:
	return tooltip % card.amount

func _on_player_hit(from: Node) -> void:
	if from is not Enemy:
		return
	
	enemy = from
	player_hit = true

func _on_enemy_action_completed(_who: Enemy) -> void:
	if not player_hit or not enemy:
		return
	
	apply_status(enemy)
