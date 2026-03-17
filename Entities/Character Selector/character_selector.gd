extends Control

const RUN_SCENE = preload("uid://c403mftopa3f6")
const WARRIOR_STATS := preload("uid://ec65km0arx71")
const WILD_KEEPER_STATS := preload("uid://fbnpo60jbtew")
const HOLY_MAGE_STATS := preload("uid://c81fpnfiu8a73")

@export var run_startup: RunStartup

@onready var title: Label = %Title
@onready var description: Label = %Description
@onready var character_portrait: TextureRect = %CharacterPortrait

var current_character: CharacterStats : set = set_current_character

func _ready() -> void:
	set_current_character(WARRIOR_STATS)

func set_current_character(new_character: CharacterStats) -> void:
	current_character = new_character
	title.text = current_character.character_name
	description.text = current_character.description
	character_portrait.texture = current_character.portrait

func _on_start_button_pressed() -> void:
	print("Start new run with %s" % current_character.character_name)
	run_startup.type = RunStartup.Type.NEW_RUN
	run_startup.picked_character = current_character
	get_tree().change_scene_to_packed(RUN_SCENE)


func _on_warrior_button_pressed() -> void:
	current_character = WARRIOR_STATS


func _on_wild_keeper_button_pressed() -> void:
	current_character = WILD_KEEPER_STATS


func _on_holy_mage_button_pressed() -> void:
	current_character = HOLY_MAGE_STATS
