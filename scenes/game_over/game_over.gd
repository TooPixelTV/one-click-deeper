extends CanvasLayer

const GAME_OVER = preload("res://assets/sounds/sfx/game_over.wav")

func _ready() -> void:
	GameData.game_over.connect(_on_game_over)

func _on_game_over():
	await get_tree().create_timer(1.5).timeout
	GameData.play_main_sfx(GAME_OVER)
	get_tree().paused = true
	%ScoreValue.text = str(GameData.kills)
	show()

func _on_button_pressed() -> void:
	get_tree().paused = false
	hide()
	GameData.new_game()
