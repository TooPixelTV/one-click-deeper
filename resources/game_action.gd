extends Resource
class_name GameAction

enum ActionSource {
	PLAYER,
	ENEMY
}

@export var level: int

var name: String
var sprite: Texture2D
var cost: int
var upgrade_cost: int
var cooldown: int = -1
var current_cooldown: int = 0

func apply(_source: ActionSource):
	pass
