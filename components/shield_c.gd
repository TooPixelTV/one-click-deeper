extends Component
class_name ShieldC

signal shield_changed

var current_shield: int = 0

func _init() -> void:
	component_name = "ShieldC"

func _ready() -> void:
	current_shield = 0

func add_shield(amount: int):
	current_shield = current_shield + amount
	shield_changed.emit()

func remove_shield(amount: int):
	current_shield = current_shield - amount
	if current_shield < 0:
		current_shield = 0
	shield_changed.emit()

func reset_shield():
	current_shield = 0
	shield_changed.emit()
	
