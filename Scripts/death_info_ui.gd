extends Control
class_name DeathInfoUI

@onready var title_label: Label = $Panel/MarginContainer/VBoxContainer/Title

@onready var from_label: Label = $Panel/MarginContainer/VBoxContainer/From/label_text
@onready var from_label_status: Label = $Panel/MarginContainer/VBoxContainer/From/label_status

@onready var clock_label: Label = $Panel/MarginContainer/VBoxContainer/Clock/label_text
@onready var clock_label_status: Label = $Panel/MarginContainer/VBoxContainer/Clock/label_status

@onready var location_label: Label = $Panel/MarginContainer/VBoxContainer/Location/label_text
@onready var location_label_status: Label = $Panel/MarginContainer/VBoxContainer/Location/label_status

func set_from_death_data(death: DeathData, contract: DeathData):
	from_label.text = DeathData.KILLED_BY_NAMES[contract.killed_by]
	from_label_status.text = "Oui" if contract.killed_by == death.killed_by else "Non"
	
	location_label.text = DeathData.LOCATION_NAMES[contract.location]
	location_label_status.text = "Oui" if contract.location == death.location else "Non"

	clock_label.text = DeathData.CLOCK_STATE_NAMES[contract.clock_state]
	clock_label_status.text = "Oui" if contract.clock_state == death.clock_state else "Non"
