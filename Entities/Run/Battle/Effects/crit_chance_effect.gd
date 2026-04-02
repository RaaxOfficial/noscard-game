class_name CritChanceEffect
extends Effect

var amount := 0.0

func execute(targets: Array[Node], _from: Node = null) -> void:
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			target.change_crit_chance(amount)
			SFXManager.play(sound)
