extends Control
class_name ContractItemUI

@onready var from_label: Label = $Panel/MarginContainer/VBoxContainer/From/label_text
@onready var date_label: Label = $Panel/MarginContainer/VBoxContainer/Date/label_text
@onready var location_label: Label = $Panel/MarginContainer/VBoxContainer/Location/label_text

var current_contract: DeathData = null

func set_from_death_condition(death_data: DeathData):
	from_label.text = DeathData.KILLED_BY_NAMES[death_data.killed_by]
	date_label.text = str(death_data.date)
	location_label.text = DeathData.LOCATION_NAMES[death_data.location]
	current_contract = death_data

func get_current_contract() -> DeathData:
	return current_contract
