extends GameAction
class_name HealGameAction

const HEAL = preload("res://assets/sounds/sfx/heal.wav")

func _init() -> void:
	name = "Heal"
	sprite = preload("res://assets/sprites/icons/heal.png")
	cost = 20
	upgrade_cost = 10
	cooldown = 5

func apply(source: ActionSource):
	if GameData._room.current_room_type == Room.RoomType.BATTLE:
		GameData.play_main_sfx(HEAL)
		var element = GameData._player
		if source == ActionSource.ENEMY:
			element = GameData._room.battle_room.current_enemy
		else:
			current_cooldown = cooldown
			
		var health_c = element.get_children().filter(func (e): return e is HealthC)[0]
		if health_c:
			(health_c as HealthC).add_health(level)
