extends Control
class_name PlayerHUD

@onready var life_bar: LifeBar = $LifeBar
@onready var clock: Clock = $Clock
@onready var location_label: Label = $LocationLabel

func set_life_bar(p_value: int, p_max_value: int):
	life_bar.set_value(p_value, p_max_value)

func show_clock_quarter(p_quarter: DeathData.ClockState) -> void:
	clock.show_quarter(p_quarter)
	
func set_location_name_to(location: DeathData.Location, is_correct: bool = false) -> void:
	location_label.text = DeathData.LOCATION_NAMES[location]
	location_label.modulate = Color.RED if is_correct else Color.WHITE
