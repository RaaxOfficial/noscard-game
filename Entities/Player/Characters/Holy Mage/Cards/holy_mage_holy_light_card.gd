extends Card

const BLIND_STATUS = preload("uid://dh0t1hba5vo5v")

@export var blind_duration := 2

func apply_effects(targets: Array[Node], sender: Node = null) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = amount
	damage_effect.sound = sound
	damage_effect.execute(targets)
	
	var status_effect := StatusEffect.new()
	var blind := BLIND_STATUS.duplicate()
	blind.duration = blind_duration
	status_effect.status = blind
	status_effect.execute(targets)
