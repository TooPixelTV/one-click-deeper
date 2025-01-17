extends Component
class_name IntentUIC

var intent_c: IntentC

func _init():
	component_name = "IntentUIC"

func _get_configuration_warnings() -> PackedStringArray:
	return required_components_warning([IntentC])

func _ready() -> void:
	intent_c = get_component(IntentC)
	if intent_c:
		intent_c.intent_changed.connect(_update_intent)


func _update_intent(game_action: GameAction):
	for element in get_children():
		element.queue_free()
	
	if not game_action:
		return
	
	for i in game_action.level:
		var texture = TextureRect.new()
		texture.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		texture.texture = game_action.sprite
		add_child(texture)
