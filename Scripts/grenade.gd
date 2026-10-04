extends RigidBody3D
class_name Grenade

@onready var explosion_area: Area3D = $Area3D

@export var damage: int = 50
@export var impulse_force: float = 10.0

func throw() -> void:
	var forward := transform.basis * Vector3.FORWARD
	apply_central_impulse(forward * impulse_force)

func _on_explosion_timer_timeout() -> void:
	queue_free()
	var targets = explosion_area.get_overlapping_bodies()
	for target in targets:
		if target.has_method("take_damage"):
			target.take_damage(damage)
		elif target.has_method("player_take_damage"):
			target.player_take_damage(damage, DeathData.KilledBy.YOURSELF)
