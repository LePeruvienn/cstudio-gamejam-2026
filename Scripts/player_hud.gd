extends Control
class_name PlayerHUD

@onready var life_bar: ProgressBar = $LifeBar

func set_life_bar(p_value: int, p_max_value: int):
	life_bar.max_value = p_max_value
	life_bar.value = p_value
