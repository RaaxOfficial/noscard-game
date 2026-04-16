extends Item

var member_var := 0


func initialize_item(_owner: ItemUI) -> void:
	print("This happens once when we acquire an item.")

func activate_item(_owner: ItemUI) -> void:
	print("This happens at specific times based on the Item.Type property.")

func deactivate_item(_onwer: ItemUI) -> void:
	print("This gets called when an ItemUI is exiting the SceneTree i.e. getting deleted.")
	print("Event-based Items should disconnect from the EventManager here.")

# We can provide unique tooltips per item if we want to
func get_tooltip() -> String:
	return tooltip
