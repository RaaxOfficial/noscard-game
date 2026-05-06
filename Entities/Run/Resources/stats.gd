class_name Stats
extends Resource

signal stats_changed

@export var max_health := 1
@export var base_dodge := 0.01
@export var base_accuracy := 1.0
@export var art: Texture
@export var sprite_frames: SpriteFrames

var health: int : set = set_health
var block: int : set = set_block
var dodge: float : set = set_dodge
var accuracy: float : set = set_accuracy

func set_health(value: int) -> void:
	health = clampi(value, 0 , max_health)
	stats_changed.emit()

func set_block(value: int) -> void:
	block = clampi(value, 0 , 999)
	stats_changed.emit()

func set_dodge(value: float) -> void:
	dodge = clampf(value, 0.0, 1.0)

func set_accuracy(value: float) -> void:
	accuracy = clampf(value, 0.0, 1.0)

func reset_dodge() -> void:
	dodge = base_dodge

func reset_accuracy() -> void:
	accuracy = base_accuracy

func take_damage(damage: int) -> void:
	if damage <= 0:
		return
	
	var initial_damage = damage
	damage = clampi(damage - block, 0, damage)
	block = clampi(block - initial_damage, 0, block)
	health -= damage

func take_piercing_damage(damage: int) -> void:
	if damage <= 0:
		return
	
	health -= damage

func heal(amount: int) -> void:
	health += amount

func skip_turn(_chance: float) -> void:
	pass

func create_instance() -> Resource:
	var instance: Stats = self.duplicate()
	instance.health = max_health
	instance.block = 0
	instance.dodge = base_dodge
	instance.accuracy = base_accuracy
	return instance
