@tool
extends Component
class_name HealthUIC

const FULL_HEART = preload("res://assets/sprites/icons/full_heart.png")
const EMPTY_HEART = preload("res://assets/sprites/icons/empty_heart.png")

var health_c: HealthC

func _get_configuration_warnings() -> PackedStringArray:
	return required_components_warning([HealthC])

func _init() -> void:
	component_name = "HealthUIC"

func _ready() -> void:
	health_c = get_component(HealthC)
	health_c.health_changed.connect(draw_health)
	draw_health()


func draw_health():
	for element in get_children():
		element.queue_free()
		
	for i in health_c.max_health:
		var texture = TextureRect.new()
		texture.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		
		if (i + 1) <= health_c.current_health:
			texture.texture = FULL_HEART
		else:
			texture.texture = EMPTY_HEART
		
		add_child(texture)
