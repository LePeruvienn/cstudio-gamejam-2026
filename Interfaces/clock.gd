extends Control
var needle_angle : float = 0
const overshoot : float = 0.02
func needle_offset():
	needle_angle += 0.10472
	var clock_tween = get_tree().create_tween()
	clock_tween.tween_property($Needle_control,"rotation",needle_angle + overshoot, 0.1)
	clock_tween.tween_property($Needle_control,"rotation",needle_angle - overshoot/2, 0.1)
	clock_tween.tween_property($Needle_control,"rotation",needle_angle, 0.1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	needle_offset()
	



func _on_timer_timeout() -> void:
	needle_offset()
