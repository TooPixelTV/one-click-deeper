extends Node2D
class_name Room

enum RoomType {
	BATTLE,
	SHOP,
	UPGRADE,
	NAVIGATION
}

@onready var battle_room: BattleRoom = $BattleRoom
@onready var upgrade_room: UpgradeRoom = $UpgradeRoom
@onready var shop_room: ShopRoom = $ShopRoom
@onready var navigation_room: NavigationRoom = $NavigationRoom

var current_room_type: RoomType

func _ready() -> void:
	GameData._room = self
	
	setup_room(RoomType.NAVIGATION)

func setup_room(type: RoomType, with_fade: bool = true):
	current_room_type = type
	
	if with_fade:
		GameData._fade_transition.fade_out()
		await GameData._fade_transition.fade_complete
	
	battle_room.hide()
	battle_room.reset_battle_room()
	upgrade_room.hide()
	shop_room.hide()
	navigation_room.hide()
	
	GameData._player.position = GameData._player_positions.get_position(PlayerPositions.PositionType.IDLE)
	GameData._player.current_position = position
	
	match current_room_type:
		RoomType.BATTLE:
			battle_room.show()
			if with_fade:
				GameData._fade_transition.fade_in()
				await GameData._fade_transition.fade_complete
			battle_room.start_battle()
		RoomType.SHOP:
			shop_room.show()
			shop_room.setup_shop()
			if with_fade:
				GameData._fade_transition.fade_in()
				await GameData._fade_transition.fade_complete
		RoomType.UPGRADE:
			upgrade_room.show()
			upgrade_room.setup_upgrade_room()
			if with_fade:
				GameData._fade_transition.fade_in()
				await GameData._fade_transition.fade_complete
		RoomType.NAVIGATION:
			navigation_room.setup_navigation()
			navigation_room.show()
			if with_fade:
				GameData._fade_transition.fade_in()
				await GameData._fade_transition.fade_complete
