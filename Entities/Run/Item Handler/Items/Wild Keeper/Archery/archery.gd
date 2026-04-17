extends Item

const WILD_KEEPER_BASIC_CARD = preload("uid://bstia0ddn1dpj")

@export var base_play_chance := 0.25

var basic_card: Card
var previous_chance: float
var chance_reduction := 0.33
var item_ui: ItemUI
var enemies: Array[Node]

func initialize_item(owner: ItemUI) -> void:
	EventManager.card_played.connect(_on_card_played)
	item_ui = owner
	basic_card = WILD_KEEPER_BASIC_CARD.duplicate()
	previous_chance = base_play_chance

func activate_item(owner: ItemUI) -> void:
	await Engine.get_main_loop().create_timer(0.3).timeout
	
	var play_chance := previous_chance
	if play_chance > randf():
		var player_modifier: ModifierHandler = owner.get_tree().get_first_node_in_group("player").find_child("ModifierHandler") as ModifierHandler
		var damage_effect := DamageEffect.new()
		damage_effect.amount = player_modifier.get_modified_value(basic_card.amount, Modifier.Type.DAMAGE_DEALT)
		damage_effect.sound = basic_card.sound
		damage_effect.execute(enemies)
		owner.flash()
		previous_chance = (play_chance + previous_chance) * chance_reduction
		activate_item(owner)
	else:
		previous_chance = base_play_chance

func deactivate_item(_onwer: ItemUI) -> void:
	if not EventManager.card_played.is_connected(_on_card_played):
		return
	EventManager.card_played.disconnect(_on_card_played)

func _on_card_played(card: Card, targets: Array[Node]) -> void:
	if not card.id == "Basic":
		return
	
	enemies = targets
	activate_item(item_ui)

func get_tooltip() -> String:
	return tooltip % [int(base_play_chance * 100), int(chance_reduction * 100)]
