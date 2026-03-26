class_name ItemView
extends Control

const ITEM_TOOLTIP := preload("uid://bcr65k7uhj82")

@onready var tooltip_container: Control = $TooltipContainer

var showing: bool = false


func _ready() -> void:
	EventManager.item_tooltip_requested.connect(_on_item_tooltip_requested)

func show_item(item: Item) -> void:
	if showing:
		return
	
	var new_item_tooltip = ITEM_TOOLTIP.instantiate() as ItemTooltip
	tooltip_container.add_child(new_item_tooltip)
	new_item_tooltip.item = item
	new_item_tooltip.global_position = get_global_mouse_position()
	tooltip_container.show()

func hide_item() -> void:
	if not showing:
		return
	
	for tooltip: ItemTooltip in tooltip_container.get_children():
		tooltip.queue_free()
	
	tooltip_container.hide()

func _on_item_tooltip_requested(item: Item) -> void:
	if showing:
		hide_item()
		showing = false
	else:
		show_item(item)
		showing = true
