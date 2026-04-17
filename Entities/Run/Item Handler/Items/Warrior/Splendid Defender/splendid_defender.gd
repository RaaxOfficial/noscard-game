extends Item

@export var chance := 0.25

var item_ui: ItemUI
var player: Player

func initialize_item(owner: ItemUI) -> void:
	EventManager.player_hurt.connect(_on_player_hurt)
	item_ui = owner

func deactivate_item(_onwer: ItemUI) -> void:
	if not EventManager.player_hurt.is_connected(_on_player_hurt):
		return
	EventManager.player_hurt.disconnect(_on_player_hurt)

func _on_player_hurt(health_lost: int) -> void:
	player = item_ui.get_tree().get_first_node_in_group("player") as Player
	if chance > randf():
		player.stats.heal(health_lost - 1)
		item_ui.flash()

func get_tooltip() -> String:
	return tooltip % int(chance * 100)
