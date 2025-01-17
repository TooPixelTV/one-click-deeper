extends Component
class_name IntentC

signal intent_changed(intent: GameAction)

var game_action_c: GameActionsC

var current_intent: GameAction

func _init() -> void:
	component_name = "IntentC"
	
func _get_configuration_warnings() -> PackedStringArray:
	return required_components_warning([GameActionsC])

func  _ready() -> void:
	game_action_c = get_component(GameActionsC)

func new_intent():
	if game_action_c:
		current_intent = game_action_c.actions.pick_random()
	else:
		current_intent = null
	
	intent_changed.emit(current_intent)
