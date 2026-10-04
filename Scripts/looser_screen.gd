extends Control
class_name LooserScreen

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var death_info_panel: DeathInfoUI = $Panel/VBoxContainer/HBoxContainer/DeathContractInterface
@onready var message_label: Label = $Panel/VBoxContainer/HBoxContainer/MarginContainer/EndRoundMessage

@export_category("Messages")
@export var win_message: String = "Bien jouer !"
@export var loose_message: String = "NUL! NUL!! NUUUL!"

@export_category("Sounds")
@export var loose_sound: AudioStream
@export var win_sound: AudioStream

signal continue_game(is_round_won: bool)

var is_round_won: bool = false

func initialize(death_data: DeathData, target_death_data: DeathData):
	death_info_panel.set_from_death_data(death_data, target_death_data)
	is_round_won = death_data.is_equal_to(target_death_data)
	if is_round_won:
		message_label.text = win_message
		audio_player.stream = win_sound
	else:
		message_label.text = loose_message
		audio_player.stream = loose_sound
	audio_player.play()

func _on_button_pressed() -> void:
	continue_game.emit(is_round_won)
