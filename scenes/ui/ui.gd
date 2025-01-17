extends CanvasLayer

@export var gold_anim_duration: float = 0.7

var tween: Tween

func _ready() -> void:
	GameData.gold_updated.connect(_on_gold_update)
	GameData.kills_updated.connect(update_kills_label)


func update_kills_label():
	%KillsValue.text = str(GameData.kills)
	

func _on_gold_update():
	if tween and tween.is_running():
		tween.stop()
	
	tween = create_tween()
	tween.tween_method(update_gold_label, int(%GoldValue.text), GameData.gold, gold_anim_duration)

func update_gold_label(new_value: int):
	%GoldValue.text = str(new_value)
