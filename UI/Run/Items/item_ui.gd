class_name ItemUI
extends Control

@export var item: Item : set = set_item

@onready var icon: TextureRect = $Icon
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func set_item(new_item: Item) -> void:
	if not is_node_ready():
		await ready
	
	item = new_item
	icon.texture = item.icon

func flash() -> void:
	animation_player.play("flash")

func _on_icon_mouse_entered() -> void:
	EventManager.item_tooltip_requested.emit(item)

func _on_icon_mouse_exited() -> void:
	EventManager.item_tooltip_requested.emit(item)
