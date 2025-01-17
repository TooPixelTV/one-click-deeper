@tool
extends Component
class_name ShieldUIC

const SHIELD = preload("res://assets/sprites/icons/shield.png")

var shield_c: ShieldC

func _get_configuration_warnings() -> PackedStringArray:
	return required_components_warning([ShieldC])

func _init() -> void:
	component_name = "ShieldUIC"

func _ready() -> void:
	shield_c = get_component(ShieldC)
	shield_c.shield_changed.connect(draw_shield)
	draw_shield()


func draw_shield():
	for element in get_children():
		element.queue_free()
		
	for i in shield_c.current_shield:
		var texture = TextureRect.new()
		texture.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		texture.texture = SHIELD
		
		add_child(texture)
