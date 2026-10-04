extends Control
class_name LooserScreen

@onready var transition_mananger: Transition = $Transition
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var death_info_panel: DeathInfoUI = $Panel/ResultContainer/HBoxContainer/DeathContractInterface
@onready var result_container: Container = $Panel/ResultContainer

@onready var panel_start: Panel = $PanelStart
@onready var panel_loose: Panel = $PanelLoose
@onready var panel_win: Panel = $PanelWin

@export_category("Sounds")
@export var loose_sound: AudioStream
@export var win_sound: AudioStream

signal continue_game(is_round_won: bool)

var is_round_won: bool = false

var current_death_data: DeathData = null
var target_death_data: DeathData = null

func initialize(p_death_data: DeathData, p_target_death_data: DeathData):
	current_death_data = p_death_data
	target_death_data = p_target_death_data
	
func setup_result_panel():
	panel_start.hide()
	result_container.show()
	if current_death_data != null and target_death_data != null:
		death_info_panel.set_from_death_data(current_death_data, target_death_data)
		is_round_won = current_death_data.is_equal_to(target_death_data)
	if is_round_won:
		audio_player.stream = win_sound
		panel_win.show()
	else:
		audio_player.stream = loose_sound
		panel_loose.show()
	audio_player.play()

func _on_button_pressed() -> void:
	print("LOOSER BTNs")
	continue_game.emit(is_round_won)

func _on_timer_timeout() -> void:
	transition_mananger.make_transition(setup_result_panel)
	$Timer.autostart = false
	$Timer.stop()
