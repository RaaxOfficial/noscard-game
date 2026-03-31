class_name Item
extends Resource

enum Type {START_OF_TURN, START_OF_COMBAT, END_OF_TURN, END_OF_COMBAT, EVENT_BASED}
enum CharacterType {ALL, WARRIOR, WILD_KEEPER, HOLY_MAGE}

@export var item_name: String
@export var id: String
@export var type: Type
@export var character_type: CharacterType
@export var starter_item: bool = false
@export var icon: Texture
@export_multiline var tooltip: String


func initialize_item(_owner: ItemUI) -> void:
	pass

func activate_item(_owner: ItemUI) -> void:
	pass

# This method should be implemented by event-based items
# which connect to the EventManager to make sure that they are
# disconnected when an item gets removed.
func deactivate_item(_onwer: ItemUI) -> void:
	pass

func get_tooltip() -> String:
	return tooltip

func can_appear_as_reward(character: CharacterStats) -> bool:
	if starter_item:
		return false
	
	if character_type == CharacterType.ALL:
		return true
	
	var item_char_name: String = CharacterType.keys()[character_type].to_lower()
	var char_name := character.character_name.to_lower()
	
	return item_char_name == char_name
