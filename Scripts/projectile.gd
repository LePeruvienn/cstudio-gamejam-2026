class_name Projectile
extends Area3D

@export var arc_height: float = 10.0
@export var rotation_speed: float = 2.0

var target: Node3D
var speed: float
var damage: int
var start_position: Vector3

func initialize(p_target: Node3D, p_speed: float, p_damage: int) -> void:
	target = p_target
	speed = p_speed
	damage = p_damage
	start_position = global_position
	look_at_from_position(start_position, target.position, Vector3.UP)

func _physics_process(delta: float) -> void:
	if not is_instance_valid(target):
		return
		
	var target_position := target.global_position
	var direction := global_position.direction_to(target_position)
	
	var target_angle: float = atan2(-direction.x, -direction.z)
	rotation.y = lerp_angle(rotation.y, target_angle, rotation_speed * delta)

	global_position += direction * speed * delta

	var progress := start_position.distance_to(global_position) / start_position.distance_to(target_position)
	progress = clamp(progress, 0.0, 1.0)

	global_position.y += sin(progress * PI) * arc_height * delta


func _on_body_entered(body: Node3D) -> void:
	if body == target:
		if target.has_method("take_damage"):
			target.take_damage(damage)
		queue_free()
