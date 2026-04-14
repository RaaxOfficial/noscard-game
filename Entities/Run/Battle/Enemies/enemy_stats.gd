class_name EnemyStats
extends Stats

@export var ai: PackedScene
@export var stunned: bool = false


func take_damage(damage: int, source: Enemy = null, from: Node = null, is_critical: bool = false, is_piercing: bool = false) -> void:
	var initial_health := health
	if not is_piercing:
		super.take_damage(damage)
	else:
		super.take_piercing_damage(damage)
	if initial_health > health:
		EventManager.enemy_hurt.emit(source, damage)
		GlobalManager.display_number(damage, source.global_position, 32, is_critical)
	
	EventManager.enemy_hit.emit(source, from)
