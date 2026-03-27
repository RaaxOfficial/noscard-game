class_name Shop
extends Control

const SHOP_CARD = preload("uid://b2f0m5nkh8w75")
const SHOP_ITEM = preload("uid://cq1t14la2uxiw")

@export var shop_items: Array[Item]
@export var char_stats: CharacterStats
@export var run_stats: RunStats
@export var item_handler: ItemHandler

@onready var cards: HBoxContainer = %Cards
@onready var items: HBoxContainer = %Items
@onready var card_tooltip_popup: CardTooltipPopup = %CardTooltipPopup
@onready var blink_timer: Timer = %BlinkTimer
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	for shop_card: ShopCard in cards.get_children():
		shop_card.queue_free()
	
	for shop_item: ShopItem in items.get_children():
		shop_item.queue_free()
	
	EventManager.shop_card_bought.connect(_on_shop_card_bought)
	EventManager.shop_item_bought.connect(_on_shop_item_bought)
	
	_blink_timer_setup()
	blink_timer.timeout.connect(_on_blink_timer_timeout)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and card_tooltip_popup.visible:
		card_tooltip_popup.hide_tooltip()

func populate_shop() -> void:
	_generate_shop_cards()
	_generate_shop_items()

func _generate_shop_cards() -> void:
	var shop_card_array: Array[Card] = []
	var available_cards := char_stats.draftable_cards.cards.duplicate(true)
	available_cards.shuffle()
	shop_card_array = available_cards.slice(0, 4)
	
	for card: Card in shop_card_array:
		var new_shop_card := SHOP_CARD.instantiate() as ShopCard
		cards.add_child(new_shop_card)
		new_shop_card.card = card
		new_shop_card.current_card_ui.tooltip_requested.connect(card_tooltip_popup.show_tooltip)
		new_shop_card.update(run_stats)

func _generate_shop_items() -> void:
	var shop_items_array: Array[Item] = []
	var available_items := shop_items.filter(
		func(item: Item):
			var can_appear := item.can_appear_as_reward(char_stats)
			var already_had_it := item_handler.has_item(item.id)
			return can_appear and not already_had_it
	)
	
	available_items.shuffle()
	shop_items_array = available_items.slice(0,4)
	
	for item: Item in shop_items_array:
		var new_shop_item := SHOP_ITEM.instantiate() as ShopItem
		items.add_child(new_shop_item)
		new_shop_item.item = item
		new_shop_item.update(run_stats)

func _update_items() -> void:
	for shop_card: ShopCard in cards.get_children():
		shop_card.update(run_stats)
	
	for shop_item: ShopItem in items.get_children():
		shop_item.update(run_stats)

func _on_shop_card_bought(card: Card, gold_cost: int) -> void:
	char_stats.deck.add_card(card)
	run_stats.gold -= gold_cost
	_update_items()

func _on_shop_item_bought(item: Item, gold_cost: int) -> void:
	item_handler.add_item(item)
	run_stats.gold -= gold_cost
	_update_items()

func _blink_timer_setup() -> void:
	blink_timer.wait_time = randf_range(1.0, 5.0)
	blink_timer.start()

func _on_blink_timer_timeout() -> void:
	animation_player.play("blink")
	_blink_timer_setup()

func _on_back_button_pressed() -> void:
	EventManager.shop_exited.emit()
