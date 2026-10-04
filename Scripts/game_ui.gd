extends CanvasLayer

@onready var game_manager: GameManager = %GameManager

var player: Player = null
var player_hud: PlayerHUD = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_instance_valid(game_manager):
		return
	player = game_manager.player_instance
	player_hud = game_manager.player_hud_instance
	if not (is_instance_valid(player) and is_instance_valid(player_hud)):
		return
	update_player_hud()
	update_player_location()
	
func update_player_hud():
	player_hud.set_life_bar(player.health, player.max_health)

func update_player_location():
	var location_manager: LocationManager = game_manager.location_manager
	var target_location := game_manager.current_contract.location
	var location := location_manager.get_current_location(player)
	player_hud.set_location_name_to(location, location == target_location)
	if location == DeathData.Location.TOP_LEFT:
		game_manager.fog_manager.set_fog_enabled(true)
	else:
		game_manager.fog_manager.set_fog_enabled(false)
