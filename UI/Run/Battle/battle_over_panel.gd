class_name BattleOverPanel
extends Panel

enum Type {WIN, LOSE}

const MAIN_MENU = preload("uid://c7oxkqjy8y15c")

@onready var label: Label = %Label
@onready var continue_button: Button = %ContinueButton
@onready var main_menu_button: Button = %MainMenuButton

func _ready() -> void:
	continue_button.pressed.connect(func(): EventManager.battle_won.emit())
	main_menu_button.pressed.connect(get_tree().change_scene_to_packed.bind(MAIN_MENU))
	EventManager.battle_over_screen_requested.connect(show_screen)

func show_screen(text: String, type: Type) -> void:
	label.text = text
	continue_button.visible = type == Type.WIN
	main_menu_button.visible = type == Type.LOSE
	show()
	get_tree().paused = true
