class_name Player
extends Node2D

const WHITE_SPRITE_MATERIAL := preload("res://art/white_sprite_material.tres")

@export var stats: CharacterStats : set = set_character_stats

@onready var stats_ui: StatsUI = $StatsUI
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var blink_timer: Timer = $BlinkTimer


func _ready() -> void:
	EventManager.player_hit.connect(_on_player_hit)
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
	
	#anim.texture = stats.art
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
		#sprite_2d.material = null
		if stats.health <= 0:
			EventManager.player_died.emit()
			queue_free()
		)

func heal(amount: int) -> void:
	if amount <= 0:
		return
	
	stats.heal(amount)

func _on_player_hit() -> void:
	#sprite_2d.material = WHITE_SPRITE_MATERIAL
	pass

func _on_blink_timer_timeout() -> void:
	if anim.is_playing():
		await anim.animation_looped
	
	anim.play("blinking")
	anim.animation_finished.connect(
		func():
		anim.play("breathing")
		)
