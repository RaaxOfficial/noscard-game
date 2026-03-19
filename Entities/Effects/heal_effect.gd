class_name HealEffect
extends Effect

var amount := 0

func execute(targets: Array[Node], from: Node = null) -> void:
	for target in targets:
		if not target:
			return
		
		if target is Player:
			target.heal(amount)
			SFXManager.play(sound)
