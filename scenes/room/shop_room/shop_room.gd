extends Node2D
class_name ShopRoom

@export var shop_items: int = 4
@export var possible_game_actions: Array[GameAction] = []
@export var min_level: int = 1
@export var max_level: int = 4

@onready var shop_game_action_roll: GameActionRoll = %ShopGameActionRoll

var roll_started: bool = false

func setup_shop():
	generate_items()
	shop_game_action_roll.start_roll()
	roll_started = true
	
func generate_items():	
	var new_selection: Array[GameAction] = []
	for i in shop_items:
		var item = generate_single_item()
		
		if item:
			new_selection.append(item)
	
	var exit_action = ExitShopGameAction.new()
	exit_action.level = 1
	new_selection.append(exit_action)
	
	shop_game_action_roll.update_game_actions(new_selection)
	

func generate_single_item():
	var game_action: GameAction = possible_game_actions.pick_random()
	if game_action:
		game_action = game_action.duplicate()
		game_action.level = randi_range(min_level, max_level)
	
	return game_action

func shop_roll_stop(game_action: GameAction, _index: int):
	if not roll_started:
		return
	
	roll_started = false
	
	if not (game_action is ExitShopGameAction):
		GameData._player.game_actions_component.actions.append(game_action)
		var fail_game_action = FailGameAction.new()
		fail_game_action.level = 1
		GameData._player.game_actions_component.actions.append(fail_game_action)
		
		var price = game_action.cost * game_action.level
		GameData.update_gold(GameData.gold - price)
	
	GameData._room.setup_room(Room.RoomType.NAVIGATION)
