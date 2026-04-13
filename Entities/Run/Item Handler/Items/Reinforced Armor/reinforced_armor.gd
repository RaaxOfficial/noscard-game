extends Item

@export var block_amount := 3


func activate_item(owner: ItemUI) -> void:
	var player := owner.get_tree().get_nodes_in_group("player")
	var block_effect = BlockEffect.new()
	block_effect.amount = block_amount
	block_effect.execute(player)
	
	owner.flash()
