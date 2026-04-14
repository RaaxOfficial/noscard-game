class_name PiercingEffect
extends Effect

var amount := 0
var receiver_modifier_type := Modifier.Type.DAMAGE_TAKEN

func execute(targets: Array[Node], from: Node = null) -> void:
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			target.take_damage(amount, receiver_modifier_type, from, true)
			SFXManager.play(sound)
