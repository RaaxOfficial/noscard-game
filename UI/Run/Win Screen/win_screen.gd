class_name WinScreen
extends Control

const MAIN_MENU_PATH = "res://UI/Main Menu/main_menu.tscn"
const TITLE := "MAP %s WON !"

@export var character: CharacterStats : set = set_character

@onready var character_portrait: TextureRect = %CharacterPortrait
@onready var title: Label = %Title


func _ready() -> void:
	EventManager.map_won.connect(_on_map_won)

func set_character(new_character: CharacterStats) -> void:
	character = new_character
	character_portrait.texture = character.portrait

func _on_map_won(map_index: int) -> void:
	title.text = TITLE % map_index

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_PATH)
