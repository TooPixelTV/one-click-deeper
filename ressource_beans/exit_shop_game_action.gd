extends GameAction
class_name ExitShopGameAction

func _init() -> void:
	name = "ExitShop"
	sprite = preload("res://assets/sprites/icons/exit.png")
	cost = 0
	upgrade_cost = 0

func apply(_source: ActionSource):
	pass
