extends GameAction
class_name ShieldGameAction

const SHIELD_IMPACT = preload("res://assets/sounds/sfx/shield_impact.wav")

func _init() -> void:
	name = "Shield"
	sprite = preload("res://assets/sprites/icons/shield.png")
	cost = 14
	upgrade_cost = 7

func apply(source: ActionSource):
	if GameData._room.current_room_type == Room.RoomType.BATTLE:
		GameData.play_main_sfx(SHIELD_IMPACT)
		var element = GameData._player
		if source == ActionSource.ENEMY:
			element = GameData._room.battle_room.current_enemy
			
		var shield_c: ShieldC = Component.get_child_component(element, ShieldC)
		if shield_c:
			shield_c.add_shield(level)
