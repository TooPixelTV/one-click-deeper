extends Node2D

func _ready() -> void:
	GameData.play_dungeon_music()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/story/story.tscn")
