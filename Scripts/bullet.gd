extends Area3D
class_name Bullet

@export var speed: float = 10.0
@export var damage: int = 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.basis * Vector3.FORWARD * speed * delta


func _on_body_entered(body: Node3D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()


func _on_life_timer_timeout() -> void:
	queue_free()
