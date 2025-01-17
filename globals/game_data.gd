extends Node

signal game_over
signal gold_updated
signal kills_updated

const dungeon_music = preload("res://assets/sounds/musics/Blood_And_Myth_LOOP_58bpm.wav")
const battle_music = preload("res://assets/sounds/musics/Chariot_Battle_LOOP_175bpm.wav")
const COIN_COLLECT = preload("res://assets/sounds/sfx/coin_collect.wav")

@export var _player: Player
@export var _room: Room
@export var _player_positions: PlayerPositions
@export var _fade_transition: FadeTransition
@export var _main_sfx: AudioStreamPlayer

var gold: int = 0
var kills: int = 0

func new_game():
	gold = 0
	gold_updated.emit()
	kills = 0
	kills_updated.emit()
	
	_room.setup_room(Room.RoomType.NAVIGATION)
	_player.reset()

func update_kills(new_value: int):
	kills = new_value
	kills_updated.emit()

func update_gold(new_value: int):
	if gold < new_value:
		play_main_sfx(COIN_COLLECT)
	
	gold = new_value
	gold_updated.emit()

func play_dungeon_music():
	BackgroundMusic.crossfade_to(dungeon_music)

func play_battle_music():
	BackgroundMusic.crossfade_to(battle_music)

func play_main_sfx(stream: AudioStream):
	#if _main_sfx.playing:
		#_main_sfx.stop()
	
	_main_sfx.stream = stream
	_main_sfx.play()
