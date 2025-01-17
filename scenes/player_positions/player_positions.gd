extends Node
class_name PlayerPositions

enum PositionType {
	IDLE,
	BATTLE,
	TOP_PORTAL,
	BOTTOM_PORTAL,
	LEFT_PORTAL,
	RIGHT_PORTAL
}

func _ready() -> void:
	GameData._player_positions = self

func get_position(type: PositionType) -> Vector2:
	match type:
		PositionType.IDLE:
			return $IdlePos.position
		PositionType.BATTLE:
			return $BattlePos.position
		PositionType.TOP_PORTAL:
			return $TopPortalPos.position
		PositionType.BOTTOM_PORTAL:
			return $BottomPortalPos.position
		PositionType.LEFT_PORTAL:
			return $LeftPortalPos.position
		PositionType.RIGHT_PORTAL:
			return $RightPortalPos.position
		_:
			return $IdlePos.position
