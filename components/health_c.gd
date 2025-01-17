extends Component
class_name  HealthC

signal health_changed

@export var max_health: int = 3

var current_health: int = 0

func _init() -> void:
	component_name = "HealthC"

func _ready() -> void:
	reset()

func add_health(amount: int):
	current_health = clamp(current_health + amount, 0, max_health)
	health_changed.emit()

func remove_health(amount: int):
	current_health = clamp(current_health - amount, 0, max_health)
	health_changed.emit()

func reset():
	current_health = max_health
	health_changed.emit()
