class_name Run
extends Node

const BATTLE_SCENE := preload("uid://beujqvtj5pjuy")
const BATTLE_REWARD_SCENE := preload("uid://dmd6nluhejqas")
const CAMPFIRE_SCENE := preload("uid://cy5xkx1g7ud4o")
const SHOP_SCENE := preload("uid://cqy15c3ypa351")
const TREASURE_SCENE := preload("uid://3aaidh4qqif3")
const WIN_SCREEN_SCENE = preload("uid://dd6mxnqr4m7gs")

@export var run_startup: RunStartup

var character: CharacterStats
var stats: RunStats

@onready var current_view: Node = $CurrentView
@onready var deck_button: CardPileOpener = %DeckButton
@onready var deck_view: CardPileView = %DeckView
@onready var health_ui: HealthUI = %HealthUI
@onready var gold_ui: GoldUI = %GoldUI
@onready var map: Map = $Map
@onready var item_handler: ItemHandler = %ItemHandler

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
			run_startup.current_act = 1
			run_startup.current_map = 1
			_start_run()
		RunStartup.Type.CONTINUED_RUN:
			print("ToDo: Generate map lmao")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("cheat"):
		get_tree().call_group("enemies", "queue_free")

func _start_run() -> void:
	stats = RunStats.new()
	_setup_event_connections()
	_setup_top_bar()
	map.generate_new_map()
	map.unlock_floor(0)

func _setup_top_bar() -> void:
	character.stats_changed.connect(health_ui.update_stats.bind(character))
	health_ui.update_stats(character)
	gold_ui.run_stats = stats
	deck_button.card_pile = character.deck
	deck_view.card_pile = character.deck
	item_handler.add_item(character.starting_item)
	deck_button.pressed.connect(deck_view.show_current_view.bind("Deck"))

func _change_view(scene: PackedScene) -> Node:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	
	get_tree().paused = false
	var new_view := scene.instantiate()
	current_view.add_child(new_view)
	map.hide_map()
	
	return new_view

func _show_map() -> void:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	
	map.show_map()
	map.unlock_next_rooms()

func _show_regular_battle_rewards() -> void:
	var reward_scene := _change_view(BATTLE_REWARD_SCENE) as BattleReward
	reward_scene.run_stats = stats
	reward_scene.character_stats = character
	
	reward_scene.add_gold_reward(map.last_room.battle_stats.roll_gold_reward())
	reward_scene.add_card_reward()

func _setup_event_connections() -> void:
	EventManager.battle_won.connect(_on_battle_won)
	EventManager.battle_reward_exited.connect(_show_map)
	EventManager.campfire_exited.connect(_show_map)
	EventManager.map_exited.connect(_on_map_exited)
	EventManager.shop_exited.connect(_show_map)
	EventManager.treasure_room_exited.connect(_on_treasure_room_exited)
	
	battle_button.pressed.connect(_change_view.bind(BATTLE_SCENE))
	battle_reward_button.pressed.connect(_change_view.bind(BATTLE_REWARD_SCENE))
	campfire_button.pressed.connect(_change_view.bind(CAMPFIRE_SCENE))
	map_button.pressed.connect(_show_map)
	shop_button.pressed.connect(_change_view.bind(SHOP_SCENE))
	treasure_button.pressed.connect(_change_view.bind(TREASURE_SCENE))

func _on_battle_room_entered(room: Room) -> void:
	var battle_scene: Battle = _change_view(BATTLE_SCENE) as Battle
	battle_scene.char_stats = character
	battle_scene.battle_stats = room.battle_stats
	battle_scene.items = item_handler
	battle_scene.start_battle()

func _on_battle_won() -> void:
	if map.floors_climbed == MapGenerator.FLOORS:
		var win_screen := _change_view(WIN_SCREEN_SCENE) as WinScreen
		win_screen.character = character
		EventManager.map_won.emit(run_startup.current_map)
		run_startup.current_map += 1
	else:
		_show_regular_battle_rewards()

func _on_treasure_room_entered() -> void:
	var treasure_scene := _change_view(TREASURE_SCENE) as Treasure
	treasure_scene.item_handler = item_handler
	treasure_scene.char_stats = character
	treasure_scene.generate_item()

func _on_treasure_room_exited(item: Item) -> void:
	var reward_scene := _change_view(BATTLE_REWARD_SCENE) as BattleReward
	reward_scene.run_stats = stats
	reward_scene.character_stats = character
	reward_scene.item_handler = item_handler
	reward_scene.add_item_reward(item)

func _on_campfire_entered() -> void:
	var campfire := _change_view(CAMPFIRE_SCENE) as Campfire
	campfire.char_stats = character

func _on_shop_entered() -> void:
	var shop := _change_view(SHOP_SCENE) as Shop
	EventManager.shop_entered.emit(shop)
	shop.char_stats = character
	shop.run_stats = stats
	shop.item_handler = item_handler
	shop.populate_shop()

func _on_map_exited(room: Room) -> void:
	match room.type:
		Room.Type.MONSTER:
			_on_battle_room_entered(room)
		Room.Type.TREASURE:
			_on_treasure_room_entered()
		Room.Type.CAMPFIRE:
			_on_campfire_entered()
		Room.Type.SHOP:
			_on_shop_entered()
		Room.Type.BOSS:
			_on_battle_room_entered(room)
