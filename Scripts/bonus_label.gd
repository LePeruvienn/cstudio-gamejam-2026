extends Control
class_name BonusLabel

@onready var label_value: Label = $HBoxContainer/LabelValue
@onready var label_name: Label = $HBoxContainer/LabelName

func set_bonus(bonus_data: BonusData) -> void:
	label_name.text = BonusData.BONUS_NAMES[bonus_data.type]
	var sign: String = "+" if bonus_data.value >= 0 else "-"
	label_value.text = "%s%.1f" % [sign, bonus_data.value]
