extends Control

@onready var death_info_panel: DeathInfoUI = $Panel/VBoxContainer/HBoxContainer/DeathContractInterface
@onready var message_label: Label = $Panel/VBoxContainer/HBoxContainer/MarginContainer/EndRoundMessage

@export var win_message: String = "Bien jouer !"
@export var loose_message: String = "NUL! NUL!! NUUUL!"

func initialize(death_data: DeathData, target_death_data: DeathData):
	death_info_panel.set_from_death_data(death_data, target_death_data)
	var is_round_won: bool = death_data.is_equal_to(target_death_data)
	if is_round_won:
		message_label.text = win_message
	else:
		message_label.text = loose_message
