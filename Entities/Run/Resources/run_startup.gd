class_name RunStartup
extends Resource

enum Type {NEW_RUN, CONTINUED_RUN}

@export var type: Type
@export var picked_character: CharacterStats
@export var current_act: int
@export var current_map: int
