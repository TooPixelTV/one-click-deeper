extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_damage_c_on_damage() -> void:
	animation_player.play("damage")
