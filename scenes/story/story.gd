extends Node2D

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		get_tree().change_scene_to_file("res://scenes/game/game.tscn")		
