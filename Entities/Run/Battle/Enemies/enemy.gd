class_name Enemy
extends Area2D

const ARROW_OFFSET := 5
const WHITE_SPRITE_MATERIAL := preload("res://art/white_sprite_material.tres")

@export var stats: EnemyStats : set = set_enemy_stats

var enemy_action_picker: EnemyActionPicker
var current_action: EnemyAction : set = set_current_action

@onready var action_animated_sprite: AnimatedSprite2D = $ActionAnimatedSprite
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var arrow: Sprite2D = $Arrow
@onready var collision: CollisionShape2D = %CollisionShape2D
@onready var stats_ui: StatsUI = $StatsUI
@onready var intent_ui: IntentUI = $IntentUI
@onready var status_handler: StatusHandler = $StatusHandler
@onready var modifier_handler: ModifierHandler = $ModifierHandler


func set_current_action(value: EnemyAction) -> void:
	current_action = value
	if current_action:
		update_intent()

func set_enemy_stats(value: EnemyStats) -> void:
	stats = value.create_instance()
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
		stats.stats_changed.connect(update_action)
	
	update_enemy()

func setup_ai() -> void:
	if enemy_action_picker:
		enemy_action_picker.queue_free()
	
	var new_action_picker: EnemyActionPicker = stats.ai.instantiate()
	add_child(new_action_picker)
	enemy_action_picker = new_action_picker
	enemy_action_picker.enemy = self

func update_stats() -> void:
	stats_ui.update_stats(stats)

func update_action() -> void:
	if not enemy_action_picker:
		return
	
	if not current_action:
		current_action = enemy_action_picker.get_action()
		return
	
	var new_conditional_action := enemy_action_picker.get_first_conditional_action()
	if new_conditional_action and current_action != new_conditional_action:
		current_action = new_conditional_action
		stats.stunned = false

func update_enemy() -> void:
	if not stats is Stats:
		return
	if not is_inside_tree():
		await ready
	
	action_animated_sprite.sprite_frames = stats.sprite_frames
	action_animated_sprite.play("idle")
	update_ui()
	setup_ai()
	update_stats()

func update_intent() -> void:
	if current_action:
		current_action.update_intent_text()
		intent_ui.update_intent(current_action.intent)

func update_ui() -> void:
	if not stats_ui:
		return
	if not intent_ui:
		return
	
	var sprite_offset: Vector2 = sprite_2d.get_rect().size
	stats_ui.global_position.y += sprite_offset.y / 2 * sprite_2d.scale.y
	intent_ui.global_position.y -= sprite_offset.y / 2 * sprite_2d.scale.y
	status_handler.global_position.y += sprite_offset.y / 2 * sprite_2d.scale.y
	
	collision.shape.extents = sprite_2d.texture.get_size() / 4
	collision.scale = sprite_2d.scale
	
	arrow.position = Vector2.RIGHT * (sprite_2d.get_rect().size.x / 2 + ARROW_OFFSET)

func do_turn() -> void:
	stats.block = 0
	
	if not current_action:
		return
	
	current_action.perform_action()

func take_damage(damage: int, which_modifier: Modifier.Type, from: Node = null, is_piercing: bool = false) -> void:
	if stats.health <= 0:
		return
	
	var source = from as Player
	if source:
		var is_hit = source.stats.accuracy - stats.dodge > randf()
		if not is_hit:
			return
	
	sprite_2d.material = WHITE_SPRITE_MATERIAL
	var modified_damage := modifier_handler.get_modified_value(damage, which_modifier)
	
	var is_critical = false
	if from as Player:
		is_critical = from.stats.crit_chance > randf()
		
		if is_critical:
			modified_damage *= from.stats.crit_damage
			ShakeManager.shake(get_parent().get_parent(), 8, 0.15)
	
	var tween := create_tween()
	tween.tween_callback(ShakeManager.shake.bind(self, 16, 0.15))
	tween.tween_callback(stats.take_damage.bind(modified_damage, self, from, is_critical, is_piercing))
	tween.tween_interval(0.17)
	
	tween.finished.connect(func():
		sprite_2d.material = null
		if stats.health <= 0:
			EventManager.enemy_died.emit(self)
			queue_free()
		)
	

func gain_block(amount: int) -> void:
	stats.block += amount

func skip_turn() -> void:
	stats.stunned = true
	update_action()

func _on_area_entered(_area: Area2D) -> void:
	arrow.show()

func _on_area_exited(_area: Area2D) -> void:
	arrow.hide()
