extends Item

@export var duration_extend := 1

var status_handler: StatusHandler
var card_played: Card
var item_ui: ItemUI

func initialize_item(owner: ItemUI) -> void:
	EventManager.card_played.connect(_on_card_played)
	item_ui = owner

func activate_item(owner: ItemUI) -> void:
	status_handler = owner.get_tree().get_first_node_in_group("player").find_child("StatusHandler") as StatusHandler
	if card_played:
		status_handler._get_status(card_played.id).duration += duration_extend

func deactivate_item(_onwer: ItemUI) -> void:
	if not EventManager.card_played.is_connected(_on_card_played):
		return
	EventManager.card_played.disconnect(_on_card_played)

func _on_card_played(card: Card, _targets: Array[Node]) -> void:
	if not card.type == Card.Type.POWER:
		return
	
	card_played = card
	activate_item(item_ui)

func get_tooltip() -> String:
	return tooltip % duration_extend
