extends PanelContainer
class_name GameActionElement

@export var game_action: GameAction
@export var display_price: bool = false
@export var is_upgrade: bool = false
@export var usable: bool = true

var active_color: Color = Color.YELLOW_GREEN
var inactive_color: Color = Color.html("#565656")
var unusable_color: Color = Color.CRIMSON

var has_cooldown: bool = false

func _ready() -> void:
	%ActionPrice.visible = display_price
	if is_upgrade:
		%ActionPrice.text = str(game_action.upgrade_cost * game_action.level)
	else:
		%ActionPrice.text = str(game_action.cost * game_action.level)
	
	var style_box = get_theme_stylebox("panel").duplicate()
	style_box.set("bg_color", inactive_color)
	add_theme_stylebox_override("panel", style_box)
	
	for i in game_action.level:
		var texture = TextureRect.new()
		texture.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		texture.texture = game_action.sprite
		custom_minimum_size = Vector2(32,32)
		%Container.add_child(texture)

func _process(_delta: float) -> void:
	if not has_cooldown and game_action.current_cooldown > 0:
		has_cooldown = true
		var style_box = get_theme_stylebox("panel").duplicate()
		style_box.set("bg_color", Color.ORANGE)
		add_theme_stylebox_override("panel", style_box)
	
	if has_cooldown and game_action.current_cooldown == 0:
		has_cooldown = false
		var style_box = get_theme_stylebox("panel").duplicate()
		style_box.set("bg_color", inactive_color)
		add_theme_stylebox_override("panel", style_box)
		

func set_active(value: bool):
	if has_cooldown:
		return
	
	var style_box = get_theme_stylebox("panel").duplicate()
	if not usable:
		style_box.set("bg_color", unusable_color)
	else:
		if value:
			style_box.set("bg_color", active_color)
		else:	
			style_box.set("bg_color", inactive_color)
	add_theme_stylebox_override("panel", style_box)
