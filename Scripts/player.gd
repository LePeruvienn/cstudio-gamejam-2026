extends CharacterBody3D

class_name Player

@onready var projectile_origin: Marker3D = $Marker3D
@onready var melee_area: Area3D = $Area3D

@export_category("Statistics")
@export var max_health: int = 100
@export var speed: float = 5.0
@export var rotation_speed: float = 5.0
@export var damage: int = 10

@export_category("Attacks")
@export var projectile_scene: PackedScene

var health: int = max_health
var is_dead: bool = false

var mouse_world_position: Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction: Vector3 =  Vector3(input_dir.x, 0, input_dir.y).normalized()
	update_mouse_world_position()
	handle_movement(direction)
	handle_rotation(delta)
	move_and_slide()
	handle_melee_attack()
	handle_projectiles()

func take_damage(damage_amount: int) -> void:
	health -= damage_amount
	if health <= 0:
		health = 0
		is_dead = true
		die()
		
func die() -> void:
	print("I DIEED")

func handle_movement(direction: Vector3) -> void:
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	pass
	
func update_mouse_world_position() -> void:
	var camera: Camera3D = get_viewport().get_camera_3d()
	if not camera:
		return
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var ray_origin: Vector3 = camera.project_ray_origin(mouse_pos)
	var ray_normal: Vector3 = camera.project_ray_normal(mouse_pos)
	var plane: Plane = Plane(Vector3.UP, Vector3.ZERO)
	var hit_point = plane.intersects_ray(ray_origin, ray_normal)
	if hit_point:
		mouse_world_position = hit_point


func handle_rotation(delta: float) -> void:
	var direction: Vector3 = (mouse_world_position - position).normalized()
	var target_angle: float = atan2(-direction.x, -direction.z)
	rotation.y = lerp_angle(rotation.y, target_angle, rotation_speed * delta)
	
func handle_projectiles() -> void:
	if not Input.is_action_just_pressed("range_attack"):
		return
	var projectile: Node3D = projectile_scene.instantiate()
	get_tree().root.add_child(projectile)
	projectile.position = projectile_origin.global_position
	projectile.rotation = rotation
	projectile.launch()
	
func handle_melee_attack() -> void:
	if not Input.is_action_just_pressed("melee_attack"):
		return
	var targets = melee_area.get_overlapping_bodies()
	for target in targets:
		if target.has_method("take_damage"):
			target.take_damage(damage)
