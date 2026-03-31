class_name Battle
extends Node2D

@export var battle_stats: BattleStats
@export var char_stats: CharacterStats
@export var items: ItemHandler
@export var music: AudioStream

@onready var battle_ui: BattleUI = $BattleUILayer
@onready var player_handler: PlayerHandler = $PlayerHandler
@onready var player: Player = $Player
@onready var enemy_handler: EnemyHandler = $EnemyHandler

func _ready() -> void:
	enemy_handler.child_order_changed.connect(_on_enemies_child_order_changed)
	EventManager.enemy_turn_ended.connect(_on_enemy_turn_ended)
	
	EventManager.player_turn_ended.connect(player_handler.end_turn)
	EventManager.player_hand_discarded.connect(enemy_handler.start_turn)
	EventManager.player_died.connect(_on_player_died)

func start_battle() -> void:
	get_tree().paused = false
	MusicManager.play(music, true)
	
	battle_ui.char_stats = char_stats
	player.stats = char_stats
	player_handler.items = items
	
	enemy_handler.setup_enemies(battle_stats)
	enemy_handler.reset_enemy_actions()
	
	items.items_activated.connect(_on_items_activated)
	items.activate_items_by_type(Item.Type.START_OF_COMBAT)

func _on_enemy_turn_ended() -> void:
	player_handler.start_turn()
	enemy_handler.reset_enemy_actions()

func _on_items_activated(type: Item.Type) -> void:
	match type:
		Item.Type.START_OF_COMBAT:
			player_handler.start_battle(char_stats)
			battle_ui.initialize_card_pile_ui()
		Item.Type.END_OF_COMBAT:
			EventManager.battle_over_screen_requested.emit("Victory!", BattleOverPanel.Type.WIN)
	

func _on_enemies_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 0 and is_instance_valid(items):
		items.activate_items_by_type(Item.Type.END_OF_COMBAT)

func _on_player_died() -> void:
	EventManager.battle_over_screen_requested.emit("Game Over!", BattleOverPanel.Type.LOSE)
	SaveGame.delete_data()
