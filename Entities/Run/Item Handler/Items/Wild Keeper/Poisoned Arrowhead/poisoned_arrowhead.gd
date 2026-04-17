extends Item

const BLEED = preload("uid://grt8ldamp306")

var stacks = 1
var item_ui: ItemUI
var enemies: Array[Node]

func initialize_item(owner: ItemUI) -> void:
	EventManager.card_played.connect(_on_card_played)
	item_ui = owner
	item_ui.flash()

func activate_item(_owner: ItemUI) -> void:
	for each in enemies:
		var status_effect := StatusEffect.new()
		var bleed := BLEED.duplicate()
		bleed.stacks = stacks
		status_effect.status = bleed
		status_effect.execute([each])

func deactivate_item(_onwer: ItemUI) -> void:
	if not EventManager.card_played.is_connected(_on_card_played):
		return
	EventManager.card_played.disconnect(_on_card_played)

func _on_card_played(card: Card, targets: Array[Node]) -> void:
	if not card.type == Card.Type.ATTACK:
		return
	
	enemies = targets
	activate_item(item_ui)
