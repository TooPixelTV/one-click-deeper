extends Control
class_name GameActionRoll

signal roll_stopped(game_action: GameAction, index: int)

const GAME_ACTION_ELEMENT = preload("res://scenes/game_action_element/game_action_element.tscn")

@export var display_price: bool = false
@export var is_upgrade: bool = false
@export var game_actions: Array[GameAction]
@export var roll_wait_time: float = 0.5
@export var accelerate_roll: bool = false
@export var acceleration_step: float = 0.01
@export var accelerate_each_cycle: int = 3

var current_active_action = 0
var min_roll_wait_time: float = 0.05
var current_cycle_count: int = 0

func _ready() -> void:
	%RollTimer.wait_time = roll_wait_time
	update_game_actions(game_actions)
	
func _process(_delta: float) -> void:
	if not %RollTimer.is_stopped():
		if Input.is_action_just_pressed("click"):
			stop_roll()

func update_game_actions(value: Array[GameAction]):
	game_actions = []
	
	for e in value:
		game_actions.append(e.duplicate(true))
	
	for element in %ActionsList.get_children().filter(func (e): return e is GameActionElement):
		element.queue_free()
	
	for game_action in game_actions:
		if is_upgrade:
			if not(game_action is FailGameAction) and not(game_action is ExitShopGameAction):
				game_action.level += 1
		
		var instance: GameActionElement = GAME_ACTION_ELEMENT.instantiate()
		instance.game_action = game_action
		instance.display_price = display_price
		instance.is_upgrade = is_upgrade
		
		if game_action is ExitShopGameAction:
			instance.display_price = false
		
		%ActionsList.add_child(instance)
		
		if display_price:
			if is_upgrade:
				if GameData.gold < game_action.upgrade_cost * game_action.level:
					instance.usable = false
					instance.set_active(false)
			else:
				if GameData.gold < game_action.cost * game_action.level:
					instance.usable = false
					instance.set_active(false)

func start_roll():
	%ClickToStop.show()
	%RollTimer.wait_time = roll_wait_time
	current_cycle_count = 0
	%RollTimer.start()

func stop_roll():
	%ClickToStop.hide()
	%EndRollSFX.play()
	%RollTimer.stop()
	roll_stopped.emit(game_actions[current_active_action], current_active_action)

func _on_roll_timer_timeout() -> void:
	%RollSFX.play()
	var elements: Array[GameActionElement]
	elements.assign(%ActionsList.get_children().filter(func (e): return e is GameActionElement))

	elements[current_active_action].set_active(false)
	current_active_action = (current_active_action + 1) % game_actions.size()
	
	if current_active_action == game_actions.size() - 1:
		current_cycle_count += 1
		if current_cycle_count >= accelerate_each_cycle:
			current_cycle_count = 0
			%RollTimer.wait_time = clamp(%RollTimer.wait_time - acceleration_step, min_roll_wait_time, roll_wait_time)
	
	if elements[current_active_action].usable\
		 and elements[current_active_action].game_action.current_cooldown == 0:
		elements[current_active_action].set_active(true)
	else:
		_on_roll_timer_timeout()
