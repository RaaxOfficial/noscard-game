class_name Player
extends Node2D

const WARRIOR_SPRITE_FRAMES = preload("uid://deowxenm3le3y") # Replace with warrior sprite frames when possible
const WILD_KEEPER_SPRITE_FRAMES = preload("uid://deowxenm3le3y")
const HOLY_MAGE_SPRITE_FRAMES = preload("uid://cquesy7j5vstq")

@export var stats: CharacterStats : set = set_character_stats

@onready var stats_ui: StatsUI = $StatsUI
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var blink_timer: Timer = $BlinkTimer


func _ready() -> void:
	EventManager.player_hit.connect(_on_player_hit)
	
	match stats.character_name:
		"Warrior":
			anim.sprite_frames = WARRIOR_SPRITE_FRAMES
		"Wild Keeper":
			anim.sprite_frames = WILD_KEEPER_SPRITE_FRAMES
		"Holy Mage":
			anim.sprite_frames = HOLY_MAGE_SPRITE_FRAMES
	
	anim.play("breathing")

func set_character_stats(value: CharacterStats) -> void:
	stats = value
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
	
	update_player()

func update_player() -> void:
	if not stats is CharacterStats:
		return
	if not is_inside_tree():
		await ready
	
	update_stats()

func update_stats() -> void:
	stats_ui.update_stats(stats)

func take_damage(damage: int) -> void:
	if stats.health <= 0:
		return
	
	var tween := create_tween()
	tween.tween_callback(ShakeManager.shake.bind(self, 16, 0.15))
	tween.tween_callback(stats.take_damage.bind(damage))
	tween.tween_interval(0.17)
	
	tween.finished.connect(func():
		if stats.health <= 0:
			EventManager.player_died.emit()
			queue_free()
		)

func heal(amount: int) -> void:
	if amount <= 0:
		return
	
	stats.heal(amount)

func _on_player_hit() -> void:
	# ToDo: Play "hurt" animation
	pass

func _on_blink_timer_timeout() -> void:
	if anim.is_playing():
		await anim.animation_looped
	
	anim.play("blinking")
	anim.animation_finished.connect(
		func():
		anim.play("breathing")
		)
