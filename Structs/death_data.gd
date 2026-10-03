class_name DeathData

const MIN_DATE: int = 20
const MAX_DATE: int = 40

enum Location
{
	TOP_LEFT,
	TOP_RIGHT,
	BOT_LEFT,
	BOT_RIGHT
}

enum KilledBy
{
	ENEMY_RANGE,
	ENEMY_MELEE,
	YOURSELF
}

const LOCATION_NAMES := {
	Location.TOP_LEFT: "Top Left",
	Location.TOP_RIGHT: "Top Right",
	Location.BOT_LEFT: "Bottom Left",
	Location.BOT_RIGHT: "Bottom Right",
}

const KILLED_BY_NAMES := {
	KilledBy.ENEMY_RANGE: "Enemy Range",
	KilledBy.ENEMY_MELEE: "Enemy Melee",
	KilledBy.YOURSELF: "Yourself",
}

var killed_by: KilledBy
var location: Location
var date: int

static func create_random() -> DeathData:
	var killed_by: KilledBy = KilledBy.values().pick_random()
	var location: Location = Location.values().pick_random()
	var date: int = randi_range(MIN_DATE, MAX_DATE)
	return DeathData.new(killed_by, location, date)

func _init(p_killed_by: KilledBy, p_location: Location, p_date: int):
	killed_by = p_killed_by
	location = p_location
	date = p_date
