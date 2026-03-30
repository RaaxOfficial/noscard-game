extends Item

@export var mana_amount := 1


func activate_item(owner: ItemUI) -> void:
	# CONNECT_ONE_SHOT disconnects the method after calling it for the first time
	if not EventManager.player_hand_drawn.is_connected(_add_mana):
		EventManager.player_hand_drawn.connect(_add_mana.bind(owner), CONNECT_ONE_SHOT)

func _add_mana(owner: ItemUI) -> void:
	owner.flash()
	var player := owner.get_tree().get_first_node_in_group("player") as Player
	if player:
		player.stats.mana += mana_amount
