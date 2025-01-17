extends Component
class_name DamageC

signal died
signal on_damage

var health_c: HealthC
var shield_c: ShieldC

func  _get_configuration_warnings() -> PackedStringArray:
	return required_components_warning([HealthC])

func _init() -> void:
	component_name = "DamageC"

func _ready() -> void:
	health_c = get_component(HealthC)
	shield_c = get_component(ShieldC)
	

func take_damage(amount: int):
	on_damage.emit()
	var remaining_amount = amount
	if shield_c:
		remaining_amount -= shield_c.current_shield
		shield_c.remove_shield(amount)
	
	if remaining_amount > 0:
		health_c.remove_health(remaining_amount)
	
	if health_c.current_health <= 0:
		died.emit()
