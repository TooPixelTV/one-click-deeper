extends Node2D
class_name Portal

enum PortalType {
	BATTLE,
	SHOP,
	UPGRADE,
}

@export var portal_type: PortalType

@export var battle_color: Color
@export var shop_color: Color
@export var upgrade_color: Color

@onready var portal: Sprite2D = $PortalBack/Portal

func _ready() -> void:
	var selected_color = battle_color
	match portal_type:
		PortalType.SHOP:
			selected_color = shop_color
		PortalType.UPGRADE:
			selected_color = upgrade_color

	portal.material.set("shader_parameter/color", selected_color)

func get_room_type() -> Room.RoomType:
	match portal_type:
		PortalType.SHOP:
			return Room.RoomType.SHOP
		PortalType.UPGRADE:
			return Room.RoomType.UPGRADE
		_, PortalType.BATTLE:
			return Room.RoomType.BATTLE
