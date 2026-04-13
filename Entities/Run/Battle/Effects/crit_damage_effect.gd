class_name CritDamageEffect
extends Effect

var amount := 0.0

func execute(targets: Array[Node], _from: Node = null) -> void:
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			target.update_crit_damage(amount)
			SFXManager.play(sound)
