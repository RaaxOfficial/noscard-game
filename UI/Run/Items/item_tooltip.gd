class_name ItemTooltip
extends PanelContainer

@export var item: Item : set = set_item

@onready var icon: TextureRect = %Icon
@onready var label: RichTextLabel = %Label


func set_item(new_item: Item) -> void:
	if not is_node_ready():
		await ready
	
	item = new_item
	icon.texture = item.icon
	label.text = item.get_tooltip()
