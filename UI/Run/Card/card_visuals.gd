class_name CardVisuals
extends Control

const BORDER_ATK_COMMON = preload("uid://cbframnl8bhhb")
const BORDER_ATK_RARE = preload("uid://vld4sdq5paw7")
const BORDER_ATK_UNCOMMON = preload("uid://chrowgal68iv3")
const BORDER_BUF_COMMON = preload("uid://bvt7rgmpy45br")
const BORDER_BUF_RARE = preload("uid://coyww4xjypa7n")
const BORDER_BUF_UNCOMMON = preload("uid://b5q5cp7j64ttp")
const BORDER_DEF_COMMON = preload("uid://crfjhedy8o0d6")
const BORDER_DEF_RARE = preload("uid://ddyau6jx0q4bj")
const BORDER_DEF_UNCOMMON = preload("uid://dr5kvahqw222t")

@export var card: Card : set = set_card

@onready var panel: Panel = $Panel
@onready var background: TextureRect = %Background
@onready var cost: Label = %Cost
@onready var icon: TextureRect = $Icon
@onready var card_type: Label = %CardType
@onready var card_value: Label = %CardValue

func set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
	
	card = value
	cost.text = str(card.cost)
	icon.texture = card.icon
	card_type.text = Card.Type.keys()[card.type]
	card_value.text = str(card.amount)
	
	#match card.type:
		#Card.Type.ATTACK:
			#if Card.Rarity.keys()[card.rarity] == Card.RARITY_COLORS[0]:
				#background.texture = BORDER_ATK_COMMON
			#elif Card.Rarity.keys()[card.rarity] == Card.RARITY_COLORS[1]:
				#background.texture = BORDER_ATK_UNCOMMON
			#else:
				#background.texture = BORDER_ATK_RARE
		#Card.Type.DEFEND:
			#if Card.Rarity.keys()[card.rarity] == Card.RARITY_COLORS[0]:
				#background.texture = BORDER_DEF_COMMON
			#elif Card.Rarity.keys()[card.rarity] == Card.RARITY_COLORS[1]:
				#background.texture = BORDER_DEF_UNCOMMON
			#else:
				#background.texture = BORDER_DEF_RARE
		#Card.Type.POWER:
			#if Card.Rarity.keys()[card.rarity] == Card.RARITY_COLORS[0]:
				#background.texture = BORDER_BUF_COMMON
			#elif Card.Rarity.keys()[card.rarity] == Card.RARITY_COLORS[1]:
				#background.texture = BORDER_BUF_UNCOMMON
			#else:
				#background.texture = BORDER_BUF_RARE
