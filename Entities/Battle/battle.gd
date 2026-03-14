extends Node2D

@export var char_stats: CharacterStats
@export var music: AudioStream

@onready var battle_ui: BattleUI = $BattleUICanvas
@onready var player_handler: PlayerHandler = $PlayerHandler
@onready var player: Player = $Player
@onready var enemy_handler: EnemyHandler = $EnemyHandler

func _ready() -> void:
	# Normally, we would do this on a "Run" level
	# so we kepp our health, gold and deck
	# between battles.
	var new_stats: CharacterStats = char_stats.create_instance()
	battle_ui.char_stats = new_stats
	player.stats = new_stats
	
	enemy_handler.child_order_changed.connect(_on_enemies_child_order_changed)
	EventManager.enemy_turn_ended.connect(_on_enemy_turn_ended)
	
	EventManager.player_turn_ended.connect(player_handler.end_turn)
	EventManager.player_hand_discarded.connect(enemy_handler.start_turn)
	EventManager.player_died.connect(_on_player_died)
	
	start_battle(new_stats)
	battle_ui.initialize_card_pìle_ui()

func start_battle(stats: CharacterStats) -> void:
	get_tree().paused = false
	MusicManager.play(music, true)
	enemy_handler.reset_enemy_actions()
	player_handler.start_battle(stats)

func _on_enemy_turn_ended() -> void:
	player_handler.start_turn()
	enemy_handler.reset_enemy_actions()

func _on_enemies_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 0:
		EventManager.battle_over_screen_requested.emit("Victory!", BattleOverPanel.Type.WIN)

func _on_player_died() -> void:
	EventManager.battle_over_screen_requested.emit("Game Over!", BattleOverPanel.Type.LOSE)
