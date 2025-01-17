extends Node2D
class_name NavigationRoom

const PORTAL = preload("res://scenes/portal/portal.tscn")
const TELEPORT = preload("res://assets/sounds/sfx/teleport.wav")

@onready var portals: Node = $Portals
@onready var arrows: Node2D = $Arrows
@onready var navigation_roll_timer: Timer = $NavigationRollTimer
@onready var portal_tuto: Node2D = $PortalTuto

var current_arrow: int = 0
var portal_pool: Array[Portal.PortalType] = []
var was_shop: bool = false

func _process(_delta: float) -> void:
	if not navigation_roll_timer.is_stopped() and Input.is_action_just_pressed("click"):
		stop_roll()

func setup_navigation():
	generate_portals()
	start_roll()
	
func start_roll():
	portal_tuto.show()
	arrows.show()
	navigation_roll_timer.start()

func stop_roll():
	portal_tuto.hide()
	%EndRollSFX.play()
	navigation_roll_timer.stop()
	await get_tree().create_timer(1).timeout
	arrows.hide()
	
	var to_position = PlayerPositions.PositionType.TOP_PORTAL
	match current_arrow:
		1:
			to_position = PlayerPositions.PositionType.RIGHT_PORTAL
		2:
			to_position = PlayerPositions.PositionType.BOTTOM_PORTAL
		3:	
			to_position = PlayerPositions.PositionType.LEFT_PORTAL
	
	GameData._player.move_to_pos(to_position)
	await GameData._player.move_end
	GameData.play_main_sfx(TELEPORT)
	move_to_new_room()
	
func move_to_new_room():
	var current_portal: Portal = portals.get_children()[current_arrow]
	
	was_shop = current_portal.get_room_type() == Portal.PortalType.SHOP\
						or current_portal.get_room_type() == Portal.PortalType.UPGRADE
	
	GameData._room.setup_room(current_portal.get_room_type())
	

func generate_portals():
	for element in portals.get_children():
		element.queue_free()
	
	portal_pool = []
	
	if was_shop:
		if randi_range(0, 1) == 0:
			portal_pool.append([Portal.PortalType.SHOP, Portal.PortalType.UPGRADE].pick_random())
	else:
		if randi_range(0, 1) == 0:
			portal_pool.append(Portal.PortalType.SHOP)
			portal_pool.append(Portal.PortalType.UPGRADE)
		else:
			portal_pool.append([Portal.PortalType.SHOP, Portal.PortalType.UPGRADE].pick_random())
	
	for i in range(portal_pool.size(), 4):
		portal_pool.append(Portal.PortalType.BATTLE)
	
	portal_pool.shuffle()
	
	generate_portal_for_pos(PlayerPositions.PositionType.TOP_PORTAL)
	generate_portal_for_pos(PlayerPositions.PositionType.RIGHT_PORTAL)
	generate_portal_for_pos(PlayerPositions.PositionType.BOTTOM_PORTAL)
	generate_portal_for_pos(PlayerPositions.PositionType.LEFT_PORTAL)

func generate_portal_for_pos(position_type: PlayerPositions.PositionType):
	var portal_type = portal_pool.pop_front()
	
	var portal_instance = PORTAL.instantiate()
	portal_instance.portal_type = portal_type
	portal_instance.position = GameData._player_positions.get_position(position_type)
	portals.add_child(portal_instance)


func _on_navigation_roll_timer_timeout() -> void:
	%RollSFX.play()
	(arrows.get_children()[current_arrow] as Sprite2D).frame = 0
	current_arrow = (current_arrow + 1) % arrows.get_child_count()
	(arrows.get_children()[current_arrow] as Sprite2D).frame = 1
