extends Node2D
class_name UpgradeRoom

@onready var upgrade_game_action_roll: GameActionRoll = $UpgradeGameActionRoll
	

func setup_upgrade_room():
	var actions: Array[GameAction] = GameData._player.game_actions_component.actions.duplicate(true)
	var exit_action: ExitShopGameAction = ExitShopGameAction.new()
	exit_action.level = 1
	
	actions.append(exit_action)
	
	upgrade_game_action_roll.update_game_actions(actions)
	upgrade_game_action_roll.start_roll()

func on_upgrade_selected(game_action: GameAction, index: int):
	if not(game_action is ExitShopGameAction):
		if game_action is FailGameAction:
			GameData._player.game_actions_component.actions.remove_at(index)
		else:
			GameData._player.game_actions_component.actions[index] = game_action
		GameData.update_gold(GameData.gold - (game_action.upgrade_cost * game_action.level))
	
	GameData._room.setup_room(Room.RoomType.NAVIGATION)
