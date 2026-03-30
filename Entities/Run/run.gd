class_name Run
extends Node

const BATTLE_SCENE := preload("uid://beujqvtj5pjuy")
const BATTLE_REWARD_SCENE := preload("uid://dmd6nluhejqas")
const CAMPFIRE_SCENE := preload("uid://cy5xkx1g7ud4o")
const SHOP_SCENE := preload("uid://cqy15c3ypa351")
const TREASURE_SCENE := preload("uid://3aaidh4qqif3")
const WIN_SCREEN_SCENE := preload("uid://dd6mxnqr4m7gs")
const MAIN_MENU_PATH := "res://UI/Main Menu/main_menu.tscn"

@export var run_startup: RunStartup

var character: CharacterStats
var stats: RunStats
var save_data: SaveGame

@onready var current_view: Node = $CurrentView
@onready var deck_button: CardPileOpener = %DeckButton
@onready var deck_view: CardPileView = %DeckView
@onready var health_ui: HealthUI = %HealthUI
@onready var gold_ui: GoldUI = %GoldUI
@onready var map: Map = $Map
@onready var item_handler: ItemHandler = %ItemHandler
@onready var pause_menu: PauseMenu = $PauseLayer


func _ready() -> void:
	if not run_startup:
		return
	
	pause_menu.save_and_quit.connect(
		func():
			get_tree().change_scene_to_file(MAIN_MENU_PATH)
	)
	
	match run_startup.type:
		RunStartup.Type.NEW_RUN:
			character = run_startup.picked_character.create_instance()
			run_startup.current_act = 1
			run_startup.current_map = 1
			_start_run()
		RunStartup.Type.CONTINUED_RUN:
			_load_run()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("cheat"):
		get_tree().call_group("enemies", "queue_free")

func _start_run() -> void:
	stats = RunStats.new()
	_setup_event_connections()
	_setup_top_bar()
	map.generate_new_map()
	map.unlock_floor(0)
	
	save_data = SaveGame.new()
	_save_run(true)

func _save_run(was_on_map: bool) -> void:
	save_data.rng_seed = RNG.instance.seed
	save_data.rng_state = RNG.instance.state
	save_data.run_stats = stats
	save_data.char_stats = character
	save_data.current_deck = character.deck
	save_data.current_health = character.health
	save_data.items = item_handler.get_all_items()
	save_data.last_room = map.last_room
	save_data.map_data = map.map_data.duplicate()
	save_data.floors_climbed = map.floors_climbed
	save_data.current_map = run_startup.current_map
	save_data.current_act = run_startup.current_act
	save_data.was_on_map = was_on_map
	save_data.save_data()

func _load_run() -> void:
	save_data = SaveGame.load_data()
	assert(save_data, "Couldn't load last save")
	
	RNG.set_from_save_data(save_data.rng_seed, save_data.rng_state)
	stats = save_data.run_stats
	character = save_data.char_stats
	character.deck = save_data.current_deck
	character.health = save_data.current_health
	item_handler.add_items(save_data.items)
	run_startup.current_map = save_data.current_map
	run_startup.current_act = save_data.current_act
	_setup_top_bar()
	_setup_event_connections()
	
	map.load_map(save_data.map_data, save_data.floors_climbed, save_data.last_room)
	if save_data.last_room and not save_data.was_on_map:
		_on_map_exited(save_data.last_room)

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
	
	_save_run(true)

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
	_save_run(false)
	
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
