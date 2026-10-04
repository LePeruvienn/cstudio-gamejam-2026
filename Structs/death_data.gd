class_name DeathData

const MIN_DATE: int = 20
const MAX_DATE: int = 40

enum Location
{
	TOP_LEFT,
	TOP_RIGHT,
	BOT_LEFT,
	BOT_RIGHT,
	NOWHERE
}

enum KilledBy
{
	ENEMY_RANGE,
	ENEMY_MELEE,
	YOURSELF
}

enum ClockState
{
	TOP_LEFT,
	TOP_RIGHT,
	BOT_LEFT,
	BOT_RIGHT
}

const LOCATION_NAMES := {
	Location.TOP_LEFT: "Top Left",
	Location.TOP_RIGHT: "Top Right",
	Location.BOT_LEFT: "Bottom Left",
	Location.BOT_RIGHT: "Bottom Right",
	Location.NOWHERE: "Nowhere"
}

const CLOCK_STATE_NAMES := {
	ClockState.TOP_LEFT: "Top Left",
	ClockState.TOP_RIGHT: "Top Right",
	ClockState.BOT_LEFT: "Bottom Left",
	ClockState.BOT_RIGHT: "Bottom Right",
}

const KILLED_BY_NAMES := {
	KilledBy.ENEMY_RANGE: "Enemy Range",
	KilledBy.ENEMY_MELEE: "Enemy Melee",
	KilledBy.YOURSELF: "Yourself",
}

var killed_by: KilledBy
var location: Location
var clock_state: ClockState

static func create_random() -> DeathData:
	var r_killed_by: KilledBy = KilledBy.values().pick_random()
	var r_location: Location = Location.values().pick_random()
	var r_clock_state: ClockState = ClockState.values().pick_random()
	return DeathData.new(r_killed_by, r_location, r_clock_state)

func _init(p_killed_by: KilledBy, p_location: Location, p_clock_state: ClockState):
	killed_by = p_killed_by
	location = p_location
	clock_state = p_clock_state

func _to_string() -> String:
	return str("Killed by: ", KILLED_BY_NAMES[killed_by], 
	", Location: ", LOCATION_NAMES[location],
	", ClockState: ", clock_state)

func is_equal_to(other: DeathData) -> bool:
	return (
		killed_by == other.killed_by
		and location == other.location
		and clock_state == other.clock_state
	)
