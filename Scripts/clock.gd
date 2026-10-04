extends Control
class_name Clock

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var heartbeat_audio_player: AudioStreamPlayer = $HeartBeatAudioPlayer

@onready var needle_control: Node2D = $Needle_control

@onready var quarter_top_right: Sprite2D = $Quarters/ClockQuarter1
@onready var quarter_bot_right: Sprite2D = $Quarters/ClockQuarter2
@onready var quarter_bot_left: Sprite2D = $Quarters/ClockQuarter3
@onready var quarter_top_left: Sprite2D = $Quarters/ClockQuarter4

@export_category("Config")
@export var rotation_per_tick: float = 6
@export var overshoot : float = 0.02

@export_category("Sounds")
@export var tick_sound: AudioStream
@export var tock_sound: AudioStream

var needle_angle: float = 0
var sound_tick: bool = true
var showed_quarter: DeathData.ClockState = DeathData.ClockState.BOT_RIGHT

func _process(delta: float) -> void:
	var current_quarter: DeathData.ClockState = get_current_quarter()
	if current_quarter == showed_quarter:
		if not heartbeat_audio_player.playing:
			heartbeat_audio_player.play()
			print("PLAYING")
	else:
		if heartbeat_audio_player.playing:
			heartbeat_audio_player.stop()

func needle_offset():
	needle_angle += deg_to_rad(rotation_per_tick)
	var clock_tween = get_tree().create_tween()
	clock_tween.tween_property($Needle_control,"rotation",needle_angle + overshoot, 0.1)
	clock_tween.tween_property($Needle_control,"rotation",needle_angle - overshoot/2, 0.1)
	clock_tween.tween_property($Needle_control,"rotation",needle_angle, 0.1)

func needle_play_sound() -> void:
	if sound_tick:
		audio_player.stream = tick_sound
	else:
		audio_player.stream = tock_sound
	audio_player.play()
	sound_tick = !sound_tick

func _on_timer_timeout() -> void:
	needle_offset()
	needle_play_sound()
	
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
	showed_quarter = p_quarter
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
			
			
