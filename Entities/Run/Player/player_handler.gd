# Player turn order:
# 1. START_OF_TURN Items
# 2. START_OF_TURN Statuses
# 3. Draw Hand
# 4. End Turn
# 5. END_OF_TURN Items
# 6. END_OF_TURN Statuses
# 7. Discard Hand
class_name PlayerHandler
extends Node

const HAND_DRAW_INTERVAL := 0.25
const HAND_DISCARD_INTERVAL := 0.25

@export var player: Player
@export var hand: Hand
@export var items: ItemHandler

var character: CharacterStats

func _ready() -> void:
	EventManager.card_played.connect(_on_card_played)

func start_battle(char_stats: CharacterStats) -> void:
	character = char_stats
	# We need to use this method because of a Godot issue
	# reported here:
	# https://github.com/godotengine/godot/issues/74918
	character.draw_pile = character.deck.custom_duplicate()
	#character.draw_pile = character.deck.duplicate_deep(Resource.DeepDuplicateMode.DEEP_DUPLICATE_ALL)
	character.draw_pile.shuffle()
	character.discard = CardPile.new()
	items.items_activated.connect(_on_items_activated)
	player.status_handler.statuses_applied.connect(_on_statuses_applied)
	start_turn()

func start_turn() -> void:
	character.block = 0
	character.reset_mana()
	items.activate_items_by_type(Item.Type.START_OF_TURN)

func end_turn() -> void:
	hand.disable_hand()
	items.activate_items_by_type(Item.Type.END_OF_TURN)

func draw_card() -> void:
	reshuffle_deck_from_discard()
	hand.add_card(character.draw_pile.draw_card())
	reshuffle_deck_from_discard()

func draw_cards(amount: int) -> void:
	var tween := create_tween()
	for i in range(amount):
		tween.tween_callback(draw_card)
		tween.tween_interval(HAND_DRAW_INTERVAL)
	
	tween.finished.connect(
		func():
			EventManager.player_hand_drawn.emit()
	)

func discard_cards() -> void:
	if hand.get_child_count() == 0:
		EventManager.player_hand_discarded.emit()
		return
	
	var tween := create_tween()
	for card_ui in hand.get_children():
		tween.tween_callback(character.discard.add_card.bind(card_ui.card))
		tween.tween_callback(hand.discard_card.bind(card_ui))
		tween.tween_interval(HAND_DISCARD_INTERVAL)
	
	tween.finished.connect(func(): EventManager.player_hand_discarded.emit())

func reshuffle_deck_from_discard() -> void:
	if not character.draw_pile.empty():
		return
	
	while not character.discard.empty():
		character.draw_pile.add_card(character.discard.draw_card())
	
	character.draw_pile.shuffle()

func _on_card_played(card: Card) -> void:
	if card.exhaustable or card.type == Card.Type.POWER:
		return
	
	character.discard.add_card(card)

func _on_items_activated(type: Item.Type) -> void:
	match type:
		Item.Type.START_OF_TURN:
			player.status_handler.apply_statuses_by_type(Status.Type.START_OF_TURN)
		Item.Type.END_OF_TURN:
			player.status_handler.apply_statuses_by_type(Status.Type.END_OF_TURN)

func _on_statuses_applied(type: Status.Type) -> void:
	match type:
		Status.Type.START_OF_TURN:
			draw_cards(character.cards_per_turn)
		Status.Type.END_OF_TURN:
			discard_cards()
