extends Card


func apply_effects(targets: Array[Node], from: Node = null) -> void:
	var block_effect := BlockEffect.new()
	block_effect.amount = amount
	block_effect.sound = sound
	block_effect.execute(targets)
