extends GameAction
class_name FailGameAction

func _init() -> void:
	name = "Fail"
	sprite = preload("res://assets/sprites/icons/fail.png")
	cost = 0
	upgrade_cost = 25

func apply(_source: ActionSource):
	pass
