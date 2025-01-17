extends Node
class_name FadeTransition

signal fade_complete

@export var transparent_by_default: bool = true
@export var fade_color: Color = Color.BLACK
@export var fade_duration: float = 1

@onready var texture_rect: ColorRect = $TextureRect

var tween: Tween

func _ready() -> void:
	GameData._fade_transition = self
	texture_rect.color = fade_color
	if transparent_by_default:
		texture_rect.modulate.a = 0
	else:
		texture_rect.modulate.a = 1

func fade_out() -> void:
	if tween and tween.is_running():
		tween.stop()
	
	tween = create_tween()
	tween.tween_property(texture_rect, "modulate:a", 1, fade_duration)
	tween.finished.connect(func (): fade_complete.emit())
	await tween.finished

func fade_in() -> void:
	if tween and tween.is_running():
		tween.stop()
	
	tween = create_tween()
	tween.tween_property(texture_rect, "modulate:a", 0, fade_duration)
	tween.finished.connect(func (): fade_complete.emit())
	await tween.finished
