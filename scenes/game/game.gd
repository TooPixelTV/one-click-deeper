extends Node2D

@onready var main_sfx: AudioStreamPlayer = $MainSFX

func _ready() -> void:
	GameData.new_game()
	GameData._main_sfx = main_sfx
