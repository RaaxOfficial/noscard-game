extends Control

const CHAR_SELECTOR_SCENE := preload("uid://d28c3q65dv8st")

@onready var continue_button: Button = %Continue


func _ready() -> void:
	get_tree().paused = false

func _on_continue_pressed() -> void:
	print("Continue run")


func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_packed(CHAR_SELECTOR_SCENE)


func _on_exit_pressed() -> void:
	get_tree().quit()
