extends CharacterBody3D
class_name Player

@onready var grenade_origin: Marker3D = $GrenadeOrigin
@onready var bullet_origin: Marker3D = $BulletOrigin
@onready var melee_area: Area3D = $Area3D

@export_category("Statistics")
@export var max_health: int = 500
@export var speed: float = 5.0
@export var rotation_speed: float = 5.0
@export var damage: int = 10

@export_category("Attacks")
@export var grenade_scene: PackedScene
@export var bullet_scene: PackedScene

var health: int = max_health
var is_dead: bool = false

var mouse_world_position: Vector3 = Vector3.ZERO

signal death(killed_by: DeathData.KilledBy)

func ready():
	$Main/AnimationPlayer.set_current_animation("idling")

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction: Vector3 =  Vector3(input_dir.x, 0, input_dir.y).normalized()
	update_mouse_world_position()
	handle_movement(direction)
	handle_rotation(delta)
	move_and_slide()
	handle_melee_attack()
	handle_grenade()
	handle_bullet()

func heal(heal_amount: int):
	health += heal_amount
	if health > max_health:
		health = max_health

func player_take_damage(damage_amount: int, p_killed_by: DeathData.KilledBy) -> void:
	health -= damage_amount
	if health <= 0:
		health = 0
		is_dead = true
		kill(p_killed_by)
		
func kill(p_killed_by: DeathData.KilledBy) -> void:
	death.emit(p_killed_by)

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
	
func handle_grenade() -> void:
	if not Input.is_action_just_pressed("throw_grenade"):
		return
	var grenade: Node3D = grenade_scene.instantiate()
	get_tree().root.add_child(grenade)
	grenade.position = bullet_origin.global_position
	grenade.rotation = rotation
	grenade.throw()
	grenade.add_to_group("projectiles")
	
func handle_bullet() -> void:
	if not Input.is_action_just_pressed("range_attack"):
		return
	var bullet: Bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.global_transform = bullet_origin.global_transform
	bullet.add_to_group("projectiles")
	
func handle_melee_attack() -> void:
	if not Input.is_action_just_pressed("melee_attack"):
		return
	var targets = melee_area.get_overlapping_bodies()
	for target in targets:
		if target.has_method("take_damage"):
			target.take_damage(damage, (target.position - position).normalized())
