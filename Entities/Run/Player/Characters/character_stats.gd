class_name CharacterStats
extends Stats

const BASE_CRIT_DAMAGE: float = 1.5

@export_group("Visuals")
@export var character_name: String
@export_multiline var description: String
@export var portrait: Texture

@export_group("Gameplay Data")
@export var starting_deck: CardPile
@export var draftable_cards: CardPile
@export var cards_per_turn: int
@export var max_mana: int
@export_range(0.0, 100.0) var base_crit_chance: float
@export var starting_item: Item

var mana: int : set = set_mana
var crit_chance: float : set = set_crit_chance
var crit_damage: float : set = set_crit_damage
var deck: CardPile
var discard: CardPile
var draw_pile: CardPile


func set_mana(value: int) -> void:
	mana = value
	stats_changed.emit()

func reset_mana() -> void:
	mana = max_mana

func set_crit_chance(value: float) -> void:
	var new_value = value / 100
	clampf(new_value, 0.0, new_value)
	crit_chance = new_value

func reset_crit_chance() -> void:
	crit_chance = base_crit_chance

func set_crit_damage(value: float) -> void:
	var new_value = value / 100
	crit_damage = BASE_CRIT_DAMAGE + clampf(new_value, 0.0, new_value)

func reset_crit_damage() -> void:
	crit_damage = BASE_CRIT_DAMAGE

func take_damage(damage: int, _from: Node = null, is_piercing: bool = false) -> void:
	var initial_health := health
	if not is_piercing:
		super.take_damage(damage)
	else:
		super.take_piercing_damage(damage)
	if initial_health > health:
		var health_lost := initial_health - health
		EventManager.player_hurt.emit(health_lost)

func can_play_card(card: Card) -> bool:
	return mana >= card.cost

func create_instance() -> Resource:
	var instance: CharacterStats = self.duplicate()
	instance.health = max_health
	instance.block = 0
	instance.reset_mana()
	instance.reset_dodge()
	instance.reset_accuracy()
	instance.reset_crit_chance()
	instance.reset_crit_damage()
	instance.deck = instance.starting_deck.duplicate()
	instance.draw_pile = CardPile.new()
	instance.discard = CardPile.new()
	return instance
