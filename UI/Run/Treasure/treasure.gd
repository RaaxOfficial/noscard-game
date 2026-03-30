class_name Treasure
extends Control

@export var treasure_item_pool: Array[Item]
@export var item_handler: ItemHandler
@export var char_stats: CharacterStats

@onready var animation_player: AnimationPlayer = %AnimationPlayer

var found_item: Item

func generate_item() -> void:
	var available_items := treasure_item_pool.filter(
		func(item: Item):
			var can_appear := item.can_appear_as_reward(char_stats)
			var already_had_it := item_handler.has_item(item.id)
			return can_appear and not already_had_it
	)
	
	found_item = RNG.array_pick_random(available_items)

# Called from the AnimationPlayer,
# at the end of the 'open' animation.
func _on_treasure_openend() -> void:
	EventManager.treasure_room_exited.emit(found_item)

func _on_treasure_chest_gui_input(event: InputEvent) -> void:
	if animation_player.current_animation == "open":
		return
	
	if event.is_action_pressed("left_mouse"):
		animation_player.play("open")
