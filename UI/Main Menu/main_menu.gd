extends Control

const CHAR_SELECTOR_SCENE := preload("uid://d28c3q65dv8st")

@onready var continue_button: Button = %Continue
@onready var wild_keeper: AnimatedSprite2D = $WildKeeper
@onready var holy_mage: AnimatedSprite2D = $HolyMage
@onready var warrior: AnimatedSprite2D = $Warrior


func _ready() -> void:
	get_tree().paused = false
	wild_keeper.play("breathing")
	holy_mage.play("breathing")
	warrior.play("breathing")

func _on_continue_pressed() -> void:
	print("Continue run")

func _on_new_run_pressed() -> void:
	get_tree().change_scene_to_packed(CHAR_SELECTOR_SCENE)

func _on_exit_pressed() -> void:
	get_tree().quit()
