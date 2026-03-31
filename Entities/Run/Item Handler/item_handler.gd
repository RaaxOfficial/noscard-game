class_name ItemHandler
extends HBoxContainer

signal items_activated(type: Item.Type)

const ITEM_APPLY_INTERVAL := 0.5
const ITEM_UI = preload("uid://dv2jyrtbb8htv")

@onready var items: HBoxContainer = %Items


func _ready() -> void:
	items.child_exiting_tree.connect(_on_items_child_exiting_tree)
	
	for item_ui: ItemUI in items.get_children():
		item_ui.free()

func activate_items_by_type(type: Item.Type) -> void:
	if type == Item.Type.EVENT_BASED:
		return
	
	var item_queue: Array[ItemUI] = _get_all_item_ui_nodes().filter(
		func(item_ui: ItemUI):
			return item_ui.item.type == type
	)
	
	if item_queue.is_empty():
		items_activated.emit(type)
		return
	
	var tween := create_tween()
	for item_ui: ItemUI in item_queue:
		tween.tween_callback(item_ui.item.activate_item.bind(item_ui))
		tween.tween_interval(ITEM_APPLY_INTERVAL)
	
	tween.finished.connect(func(): items_activated.emit(type))

func add_items(items_array: Array[Item]) -> void:
	for item: Item in items_array:
		add_item(item)

func add_item(item: Item) -> void:
	if has_item(item.id):
		return
	
	var new_item_ui := ITEM_UI.instantiate() as ItemUI
	items.add_child(new_item_ui)
	new_item_ui.item = item
	new_item_ui.item.initialize_item(new_item_ui)

func has_item(id: String) -> bool:
	for item_ui: ItemUI in items.get_children():
		if item_ui.item.id == id and is_instance_valid(item_ui):
			return true
	
	return false

func get_all_items() -> Array[Item]:
	var item_ui_nodes := _get_all_item_ui_nodes()
	var items_array: Array[Item] = []
	
	for item_ui: ItemUI in item_ui_nodes:
		items_array.append(item_ui.item)
	
	return items_array

func _get_all_item_ui_nodes() -> Array[ItemUI]:
	var all_items: Array[ItemUI] = []
	for item_ui: ItemUI in items.get_children():
		all_items.append(item_ui)
	
	return all_items

func _on_items_child_exiting_tree(item_ui: ItemUI) -> void:
	if not item_ui:
		return
	
	if item_ui.item:
		item_ui.item.deactivate_item(item_ui)
