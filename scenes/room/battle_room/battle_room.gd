extends Node2D
class_name BattleRoom

@onready var enemy_position: Marker2D = $EnemyPosition
@onready var game_action_roll: GameActionRoll = %GameActionRoll

@export var enemies: Array[PackedScene] = []

var current_enemy: Node2D
var battle_running: bool = false

func start_battle():
	GameData.play_battle_music()
	battle_running = true
	GameData._player.move_to_pos(PlayerPositions.PositionType.BATTLE)
	await GameData._player.move_end
	
	var enemy_type: PackedScene = select_new_enemy()
	
	current_enemy = enemy_type.instantiate()
	current_enemy.position = enemy_position.position
	
	add_child(current_enemy)
	
	var damage_c: DamageC = Component.get_child_component(current_enemy, DamageC)
	if damage_c:
		damage_c.died.connect(_enemy_died)
	
	init_actions_roll()
	new_round()

func select_new_enemy() -> PackedScene:
	var current_score = GameData.kills
	
	if current_score < 2:
		return enemies[0]
	
	if current_score < 6:
		return [enemies[0], enemies[1]].pick_random()
	
	return [enemies[0], enemies[1], enemies[2]].pick_random()

func init_actions_roll():
	var game_actions = GameData._player.game_actions_component.actions.duplicate(true)
	game_actions.shuffle()
	game_action_roll.update_game_actions(game_actions)
	game_action_roll.show()


func new_round():
	var player_health_c: HealthC = Component.get_child_component(GameData._player, HealthC)
	if player_health_c and player_health_c.current_health <= 0:
		return
		
	var intent_c: IntentC = Component.get_child_component(current_enemy, IntentC)
	if intent_c:
		intent_c.new_intent()
		
	for action in game_action_roll.game_actions:
		if action.current_cooldown > 0:
			action.current_cooldown = clamp(action.current_cooldown - 1, 0, action.cooldown)
		
	game_action_roll.start_roll()

func apply_enemy_intent():
	var intent_c: IntentC = Component.get_child_component(current_enemy, IntentC)
	if intent_c and intent_c.current_intent:
		intent_c.current_intent.apply(GameAction.ActionSource.ENEMY)
		

func _on_game_action_roll_roll_stopped(game_action: GameAction, _index: int) -> void:
	game_action.apply(GameAction.ActionSource.PLAYER)
	
	if battle_running:
		await get_tree().create_timer(0.5).timeout
		apply_enemy_intent()
		await get_tree().create_timer(3).timeout
		new_round()
	else:
		reset_battle_room()

func _enemy_died():
	battle_running = false
	
	GameData.update_kills(GameData.kills + 1)
	
	var reward_c: RewardC = Component.get_child_component(current_enemy, RewardC)
	if reward_c:
		GameData.update_gold(GameData.gold + reward_c.gold)
	
	reset_battle_room()
	
	GameData._player.move_to_pos(PlayerPositions.PositionType.IDLE)
	await GameData._player.move_end
	await get_tree().create_timer(1).timeout
	call_deferred("end_battle")
	
func end_battle():
	GameData.play_dungeon_music()
	GameData._room.setup_room(Room.RoomType.NAVIGATION, false)

func reset_battle_room():
	var player_shield_c: ShieldC = Component.get_child_component(GameData._player, ShieldC)
	if player_shield_c:
		player_shield_c.reset_shield()
	
	if current_enemy:
		current_enemy.queue_free()
		current_enemy = null
	game_action_roll.update_game_actions([])
	game_action_roll.hide()
