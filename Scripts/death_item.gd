extends Control
class_name ContractItemUI

@onready var from_label: Label = $Panel/MarginContainer/VBoxContainer/From/label_text
@onready var date_label: Label = $Panel/MarginContainer/VBoxContainer/Clock/label_text
@onready var location_label: Label = $Panel/MarginContainer/VBoxContainer/Location/label_text

var current_contract: DeathData = null

signal choice_made(contract: DeathData)

func set_from_death_condition(death_data: DeathData):
	from_label.text = DeathData.KILLED_BY_NAMES[death_data.killed_by]
	date_label.text = DeathData.CLOCK_STATE_NAMES[death_data.clock_state]
	location_label.text = DeathData.LOCATION_NAMES[death_data.location]
	current_contract = death_data

func get_current_contract() -> DeathData:
	return current_contract

func _on_button_pressed() -> void:
	choice_made.emit(current_contract)
