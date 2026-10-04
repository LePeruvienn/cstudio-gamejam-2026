extends Control
class_name LifeBar

@onready var progress_bar: ProgressBar = $ProgressBar

@export var animation_duration: float = 0.3

func set_value(health: float, max_health: float) -> void:
	progress_bar.max_value = max_health
	var tween := create_tween()
	tween.tween_property(
		progress_bar,
		"value",
		health,
		animation_duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
