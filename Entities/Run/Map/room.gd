class_name Room
extends Resource

enum Type {NOT_ASSIGNED, MONSTER, TREASURE, CAMPFIRE, SHOP, BOSS}

@export var type: Type
@export var row: int
@export var column: int
@export var position: Vector2
@export var next_rooms: Array[Room]
@export var selected := false
# Only used by MONSTER and BOSS types
@export var battle_stats: BattleStats


# Testing purposes
func _to_string() -> String:
	# Type.keys() returns the enum values as an array of strings. 
	# We access the room type with keys()[type],
	# and return only the first letter with [0].
	return "%s (%s)" % [column, Type.keys()[type][0]]
