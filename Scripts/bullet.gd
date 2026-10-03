extends RigidBody3D

@export var impulse_force: float = 20.0

func launch() -> void:
	var forward := transform.basis * Vector3.FORWARD
	apply_central_impulse(forward * impulse_force)

func _on_body_entered(body: Node) -> void:
	queue_free()
