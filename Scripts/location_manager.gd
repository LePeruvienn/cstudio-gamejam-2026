extends Node3D
class_name LocationManager

@onready var locations := {
	DeathData.Location.TOP_RIGHT: $TopRightArea,
	DeathData.Location.TOP_LEFT: $TopLeftArea,
	DeathData.Location.BOT_RIGHT: $BotRightArea,
	DeathData.Location.BOT_LEFT: $BotLeftArea,
}

func get_current_location(player: Player) -> DeathData.Location:
	for location: DeathData.Location in locations:
		var area: Area3D = locations[location]
		if area.overlaps_body(player):
			return location
	return DeathData.Location.NOWHERE
