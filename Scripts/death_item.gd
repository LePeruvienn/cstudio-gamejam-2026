extends Control
class_name ContractItemUI

@onready var from_label: Label = $Panel/MarginContainer/VBoxContainer/From/label_text
@onready var date_label: Label = $Panel/MarginContainer/VBoxContainer/Clock/label_text
@onready var location_label: Label = $Panel/MarginContainer/VBoxContainer/Location/label_text
@onready var bonus_label: BonusLabel = $Panel/MarginContainer/VBoxContainer/BonusLabel

var current_contract: DeathData = null
var current_bonus: BonusData = null

signal choice_made(contract: DeathData, bonus: BonusData)

func set_data(death_data: DeathData, bonus_data: BonusData):
	from_label.text = DeathData.KILLED_BY_NAMES[death_data.killed_by]
	date_label.text = DeathData.CLOCK_STATE_NAMES[death_data.clock_state]
	location_label.text = DeathData.LOCATION_NAMES[death_data.location]
	bonus_label.set_bonus(bonus_data)
	current_contract = death_data
	current_bonus = bonus_data

func _on_button_pressed() -> void:
	choice_made.emit(current_contract, current_bonus)
