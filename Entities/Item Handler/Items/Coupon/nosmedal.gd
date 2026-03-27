class_name NosmedalItem
extends Item

@export_range(1, 100) var discount := 50

var item_ui: ItemUI

func initialize_item(owner: ItemUI) -> void:
	EventManager.shop_entered.connect(add_shop_modifier)
	item_ui = owner

func deactivate_item(_owner: ItemUI) -> void:
	EventManager.shop_entered.disconnect(add_shop_modifier)

func add_shop_modifier(shop: Shop) -> void:
	item_ui.flash()
	
	var shop_cost_modifier := shop.modifier_handler.get_modifier(Modifier.Type.SHOP_COST)
	assert(shop_cost_modifier, "No shop cost modifier in shop!")
	
	var coupon_modifier_value := shop_cost_modifier.get_value("coupon")
	
	if not coupon_modifier_value:
		coupon_modifier_value = ModifierValue.create_new_modifier("coupon", ModifierValue.Type.PERCENT_BASED)
		coupon_modifier_value.percent_value = -1 * discount / 100.0 # -50% so it DISCOUNTS the price
		shop_cost_modifier.add_new_value(coupon_modifier_value)
