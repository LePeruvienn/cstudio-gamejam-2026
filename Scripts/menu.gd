extends Control
class_name Menu

signal pressed_play()

func _on_button_pressed() -> void:
	pressed_play.emit()
