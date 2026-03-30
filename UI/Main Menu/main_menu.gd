extends Control

const CHAR_SELECTOR_SCENE := preload("uid://d28c3q65dv8st")
const RUN_SCENE := preload("uid://c403mftopa3f6")

@export var run_startup: RunStartup

@onready var continue_button: Button = %Continue


func _ready() -> void:
	get_tree().paused = false
	continue_button.disabled = SaveGame.load_data() == null

func _on_continue_pressed() -> void:
	run_startup.type = RunStartup.Type.CONTINUED_RUN
	get_tree().change_scene_to_packed(RUN_SCENE)

func _on_new_run_pressed() -> void:
	get_tree().change_scene_to_packed(CHAR_SELECTOR_SCENE)

func _on_exit_pressed() -> void:
	get_tree().quit()
