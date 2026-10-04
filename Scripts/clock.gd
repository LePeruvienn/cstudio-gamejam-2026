extends Control
class_name Clock

@onready var needle_control: Node2D = $Needle_control

@onready var quarter_top_right: Sprite2D = $Quarters/ClockQuarter1
@onready var quarter_bot_right: Sprite2D = $Quarters/ClockQuarter2
@onready var quarter_bot_left: Sprite2D = $Quarters/ClockQuarter3
@onready var quarter_top_left: Sprite2D = $Quarters/ClockQuarter4

@export var rotation_per_tick: float = 6
@export var overshoot : float = 0.02

var needle_angle: float = 0

func needle_offset():
	needle_angle += deg_to_rad(rotation_per_tick)
	var clock_tween = get_tree().create_tween()
	clock_tween.tween_property($Needle_control,"rotation",needle_angle + overshoot, 0.1)
	clock_tween.tween_property($Needle_control,"rotation",needle_angle - overshoot/2, 0.1)
	clock_tween.tween_property($Needle_control,"rotation",needle_angle, 0.1)

func _on_timer_timeout() -> void:
	needle_offset()
	
func get_current_quarter() -> DeathData.ClockState:
	var angle: float = fposmod(needle_control.rotation, TAU)
	if angle > TAU * 3.0 / 4.0:
		return DeathData.ClockState.TOP_LEFT
	elif angle > PI:
		return DeathData.ClockState.BOT_LEFT
	elif angle > PI / 2.0:
		return DeathData.ClockState.BOT_RIGHT
	else:
		return DeathData.ClockState.TOP_RIGHT
		
func hide_all_quarters() -> void:
	quarter_top_right.hide()
	quarter_bot_right.hide()
	quarter_bot_left.hide()
	quarter_top_left.hide()
		
func show_quarter(p_quarter: DeathData.ClockState) -> void:
	hide_all_quarters()
	match p_quarter:
		DeathData.ClockState.TOP_LEFT:
			quarter_top_left.show()
		DeathData.ClockState.TOP_RIGHT:
			quarter_top_right.show()
		DeathData.ClockState.BOT_LEFT:
			quarter_bot_left.show()
		DeathData.ClockState.BOT_RIGHT:
			quarter_bot_right.show()
			
			
