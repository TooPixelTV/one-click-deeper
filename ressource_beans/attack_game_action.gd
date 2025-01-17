extends GameAction
class_name AttackGameAction

const WEAPON_ATTACK = preload("res://assets/sounds/sfx/weapon_attack.wav")

func _init() -> void:
	name = "Attack"
	sprite = preload("res://assets/sprites/icons/attack.png")
	cost = 10
	upgrade_cost = 5

func apply(source: ActionSource):
	if GameData._room.current_room_type == Room.RoomType.BATTLE:
		if source == ActionSource.PLAYER:
			GameData.play_main_sfx(WEAPON_ATTACK)
			var enemy = GameData._room.battle_room.current_enemy
			var damage_c: DamageC = Component.get_child_component(enemy, DamageC)
			if damage_c:
				damage_c.take_damage(level)
		elif  source == ActionSource.ENEMY:
			var damage_c: DamageC = Component.get_child_component(GameData._player, DamageC)
			if damage_c:
				damage_c.take_damage(level)
			
