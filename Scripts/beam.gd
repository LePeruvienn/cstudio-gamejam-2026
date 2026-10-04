extends MeshInstance3D
class_name Beam

@export var thickness: float = 0.1

func update_beam(start: Vector3, end: Vector3) -> void:
	var direction := end - start
	var distance := direction.length()

	global_position = (start + end) / 2.0

	look_at(end, Vector3.UP)
	rotate_object_local(Vector3.RIGHT, PI / 2.0)

	scale = Vector3(thickness, distance / 2.0, thickness)
