class_name ShopItem
extends VBoxContainer

const ITEM_UI = preload("uid://dv2jyrtbb8htv")

@export var item: Item : set = set_item

@onready var item_container: CenterContainer = %ItemContainer
@onready var price: HBoxContainer = %Price
@onready var price_label: Label = %PriceLabel
@onready var buy_button: Button = %BuyButton
@onready var gold_cost := RNG.instance.randi_range(100, 300)


func update(run_stats: RunStats) -> void:
	if not item_container or not price or not buy_button:
		return
	
	price_label.text = str(gold_cost)
	
	if run_stats.gold >= gold_cost:
		price_label.remove_theme_color_override("font_color")
		buy_button.disabled = false
	else:
		price_label.add_theme_color_override("font_color", Color.RED)
		buy_button.disabled = true
	
	

func set_item(new_item: Item) -> void:
	if not is_node_ready():
		await ready
	
	item = new_item
	
	for item_ui: ItemUI in item_container.get_children():
		item_ui.queue_free()
	
	var new_item_ui := ITEM_UI.instantiate() as ItemUI
	item_container.add_child(new_item_ui)
	new_item_ui.item = item

func _on_buy_button_pressed() -> void:
	EventManager.shop_item_bought.emit(item, gold_cost)
	item_container.queue_free()
	price.queue_free()
	buy_button.queue_free()
