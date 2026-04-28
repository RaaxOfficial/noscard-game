class_name Player
extends Node2D

const WARRIOR_SPRITE_FRAMES = preload("uid://cpsu5kgpl3h2b")
const WILD_KEEPER_SPRITE_FRAMES = preload("uid://deowxenm3le3y")
const HOLY_MAGE_SPRITE_FRAMES = preload("uid://cquesy7j5vstq")

@export var stats: CharacterStats : set = set_character_stats

@onready var stats_ui: StatsUI = $StatsUI
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var blink_timer: Timer = $BlinkTimer
@onready var status_handler: StatusHandler = $StatusHandler
@onready var modifier_handler: ModifierHandler = $ModifierHandler
@onready var attack_anim_sprite: AnimatedSprite2D = $AttackAnimatedSprite


func _ready() -> void:
	EventManager.player_hurt.connect(_on_player_hurt)
	status_handler.status_owner = self
	anim.play("breathing")

func set_character_stats(value: CharacterStats) -> void:
	stats = value
	
	stats.reset_dodge()
	stats.reset_accuracy()
	update_crit_chance(value.base_crit_chance)
	update_crit_damage(value.BASE_CRIT_DAMAGE)
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
	
	update_player()

func update_player() -> void:
	if not stats is CharacterStats:
		return
	if not is_inside_tree():
		await ready
	
	match stats.character_name:
		"Warrior":
			anim.sprite_frames = WARRIOR_SPRITE_FRAMES
		"Wild_Keeper":
			anim.sprite_frames = WILD_KEEPER_SPRITE_FRAMES
		"Holy_Mage":
			anim.sprite_frames = HOLY_MAGE_SPRITE_FRAMES
	
	update_stats()

func update_stats() -> void:
	stats_ui.update_stats(stats)

func take_damage(damage: int, which_modifier: Modifier.Type, from: Node = null, is_piercing: bool = false) -> void:
	if stats.health <= 0:
		return
	
	var source = from as Enemy
	var is_hit = source.stats.accuracy - stats.dodge > randf()
	if not is_hit:
		return
	
	var modified_damage := modifier_handler.get_modified_value(damage, which_modifier)
	
	var tween := create_tween()
	tween.tween_callback(ShakeManager.shake.bind(self, 16, 0.15))
	tween.tween_callback(stats.take_damage.bind(modified_damage, from, is_piercing))
	tween.tween_interval(0.17)
	
	tween.finished.connect(func():
		if stats.health <= 0:
			EventManager.player_died.emit()
			queue_free()
		)
	EventManager.player_hit.emit(from, self)

func gain_block(amount: int) -> void:
	stats.block += amount

func heal(amount: int) -> void:
	if amount <= 0:
		return
	
	stats.heal(amount)

func update_crit_chance(value: float) -> void:
	stats.crit_chance = value

func update_crit_damage(value: float) -> void:
	stats.crit_damage = value

func skip_turn() -> void:
	print("Player has skipped turn")

func play_attack_animation(targets: Array[Node]) -> void:
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			attack_anim_sprite.visible = true
			attack_anim_sprite.global_position = target.global_position
			attack_anim_sprite.play()
			await attack_anim_sprite.animation_finished
			attack_anim_sprite.visible = false

func _on_player_hurt(health_lost: int) -> void:
	print("ToDo: anim.play(hurt)")
	
	if status_handler._has_status("Mana Shield"):
		var status = status_handler._get_status("Mana Shield") as ManaShieldStatus
		if health_lost >= status.hp_threshold:
			health_lost = 1
	
	GlobalManager.display_number(health_lost, global_position, 32)

func _on_blink_timer_timeout() -> void:
	if anim.is_playing():
		await anim.animation_looped
	
	anim.play("blinking")
	anim.animation_finished.connect(
		func():
		anim.play("breathing")
		)
