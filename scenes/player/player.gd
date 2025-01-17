extends Node2D
class_name  Player

signal move_end

@export var game_actions_component: GameActionsC
@export var move_speed: float = 100.0

const ARMOR_HIT = preload("res://assets/sounds/sfx/armor_hit.wav")

var walk_sounds: Array[AudioStream] = [
	preload("res://assets/sounds/sfx/move/Fantasy_Game_Footstep_Stone_Heavy_A.wav"),
	preload("res://assets/sounds/sfx/move/Fantasy_Game_Footstep_Stone_Heavy_B.wav"),
	preload("res://assets/sounds/sfx/move/Fantasy_Game_Footstep_Stone_Heavy_C.wav"),
	preload("res://assets/sounds/sfx/move/Fantasy_Game_Footstep_Stone_Heavy_D.wav"),
	preload("res://assets/sounds/sfx/move/Fantasy_Game_Footstep_Stone_Heavy_E.wav"),
	preload("res://assets/sounds/sfx/move/Fantasy_Game_Footstep_Stone_Heavy_F.wav"),
	preload("res://assets/sounds/sfx/move/Fantasy_Game_Footstep_Stone_Heavy_G.wav"),
	preload("res://assets/sounds/sfx/move/Fantasy_Game_Footstep_Stone_Heavy_H.wav"),
	preload("res://assets/sounds/sfx/move/Fantasy_Game_Footstep_Stone_Heavy_I.wav"),
	preload("res://assets/sounds/sfx/move/Fantasy_Game_Footstep_Stone_Heavy_J.wav")
]

@onready var walk_sound: AudioStreamPlayer = $WalkSound
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var current_position: Vector2 = Vector2.ZERO
var target_reached: bool = true

func _ready() -> void:
	GameData._player = self
	var damage_c: DamageC = Component.get_child_component(self, DamageC)
	if damage_c:
		damage_c.died.connect(GameData.game_over.emit)

func _process(delta: float) -> void:
	if not target_reached and (position == current_position || position.distance_to(current_position) <= 1):
		move_end.emit()
		%WalkTimer.stop()
		animation_player.stop()
		animation_player.play("RESET")
		target_reached = true
	
	if position != current_position:
		if position.distance_to(current_position) > 1:
			var direction = position.direction_to(current_position)
			position += direction * move_speed * delta
		else:
			position = current_position

func move_to_pos(type: PlayerPositions.PositionType):
	%WalkTimer.start()
	animation_player.play("walk")
	current_position = GameData._player_positions.get_position(type)
	target_reached = false


func _on_walk_timer_timeout() -> void:
	walk_sound.stream = walk_sounds.pick_random()
	walk_sound.play()
	
func _on_damage_c_on_damage() -> void:
	animation_player.play("damage")
	GameData.play_main_sfx(ARMOR_HIT)

func reset() -> void:
	var health_c: HealthC = Component.get_child_component(self, HealthC)
	if health_c:
		health_c.reset()
	
	var game_actions_c: GameActionsC = Component.get_child_component(self, GameActionsC)
	if game_actions_c:
		var actions: Array[GameAction] = []
		
		var attack_action: AttackGameAction = AttackGameAction.new()
		attack_action.level = 1
		
		actions.append(attack_action.duplicate(true))
		actions.append(attack_action.duplicate(true))
		
		var shield_action: ShieldGameAction = ShieldGameAction.new()
		shield_action.level = 2
		
		actions.append(shield_action.duplicate(true))
		
		var fail_action: FailGameAction = FailGameAction.new()
		fail_action.level = 1
		
		actions.append(fail_action.duplicate(true))
		actions.append(fail_action.duplicate(true))
		
		game_actions_c.actions = actions
