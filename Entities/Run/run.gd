class_name Run
extends Node

const BATTLE_SCENE := preload("uid://beujqvtj5pjuy")
const BATTLE_REWARD_SCENE := preload("uid://dmd6nluhejqas")
const CAMPFIRE_SCENE := preload("uid://cy5xkx1g7ud4o")
const MAP_SCENE := preload("uid://v2uwtsply7kf")
const SHOP_SCENE := preload("uid://cqy15c3ypa351")
const TREASURE_SCENE := preload("uid://3aaidh4qqif3")

@export var run_startup: RunStartup

var character: CharacterStats
var stats: RunStats

@onready var current_view: Node = $CurrentView
@onready var deck_button: CardPileOpener = %DeckButton
@onready var deck_view: CardPileView = %DeckView
@onready var gold_ui: GoldUI = %GoldUI

# Debugging Buttons
@onready var map_button: Button = %MapButton
@onready var battle_button: Button = %BattleButton
@onready var shop_button: Button = %ShopButton
@onready var campfire_button: Button = %CampfireButton
@onready var treasure_button: Button = %TreasureButton
@onready var battle_reward_button: Button = %BattleRewardButton


func _ready() -> void:
	if not run_startup:
		return
	
	match run_startup.type:
		RunStartup.Type.NEW_RUN:
			character = run_startup.picked_character.create_instance()
			_start_run()
		RunStartup.Type.CONTINUED_RUN:
			print("ToDo: Generate map lmao")

func _start_run() -> void:
	stats = RunStats.new()
	_setup_event_connections()
	_setup_top_bar()
	print("ToDo: Generate map lol")

func _setup_top_bar() -> void:
	gold_ui.run_stats = stats
	deck_button.card_pile = character.deck
	deck_view.card_pile = character.deck
	deck_button.pressed.connect(deck_view.show_current_view.bind("Deck"))

func _change_view(scene: PackedScene) -> Node:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	
	get_tree().paused = false
	var new_view := scene.instantiate()
	current_view.add_child(new_view)
	
	return new_view

func _on_battle_won() -> void:
	var reward_scene := _change_view(BATTLE_REWARD_SCENE) as BattleReward
	reward_scene.run_stats = stats
	reward_scene.character_stats = character
	
	# Temporary code, it will come from real battle encounter data
	reward_scene.add_gold_reward(77)
	reward_scene.add_card_reward()

func _setup_event_connections() -> void:
	EventManager.battle_won.connect(_on_battle_won)
	EventManager.battle_reward_exited.connect(_change_view.bind(MAP_SCENE))
	EventManager.campfire_exited.connect(_change_view.bind(MAP_SCENE))
	EventManager.map_exited.connect(_on_map_exited)
	EventManager.shop_exited.connect(_change_view.bind(MAP_SCENE))
	EventManager.treasure_room_exited.connect(_change_view.bind(MAP_SCENE))
	
	battle_button.pressed.connect(_change_view.bind(BATTLE_SCENE))
	battle_reward_button.pressed.connect(_change_view.bind(BATTLE_REWARD_SCENE))
	campfire_button.pressed.connect(_change_view.bind(CAMPFIRE_SCENE))
	map_button.pressed.connect(_change_view.bind(MAP_SCENE))
	shop_button.pressed.connect(_change_view.bind(SHOP_SCENE))
	treasure_button.pressed.connect(_change_view.bind(TREASURE_SCENE))

func _on_map_exited() -> void:
	print("ToDo: from the MAP, change view based on room type")
