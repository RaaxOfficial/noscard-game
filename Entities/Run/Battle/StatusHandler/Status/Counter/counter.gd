class_name CounterStatus
extends Status

@export var card: Card
var player: Node

func initialize_status(_target: Node) -> void:
	if not EventManager.player_hit.is_connected(_on_player_hit):
		EventManager.player_hit.connect(_on_player_hit)

func apply_status(target: Node) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = card.amount
	damage_effect.sound = card.sound
	damage_effect.execute([target], player)
	status_applied.emit(self)

func get_tooltip() -> String:
	return tooltip % card.amount

func _on_player_hit(from: Node, player_hit: Node) -> void:
	if from is not Enemy or not player_hit:
		return
	
	player = player_hit
	apply_status(from)
