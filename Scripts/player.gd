extends CharacterBody3D
class_name Player

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var audio_attack_player: AudioStreamPlayer3D = $AudioStreamPlayers/AttackPlayer
@onready var audio_damage_taken_player: AudioStreamPlayer3D = $AudioStreamPlayers/DamageTakenPlayer
@onready var audio_heal_player: AudioStreamPlayer3D = $AudioStreamPlayers/HealPlayer

@onready var grenade_origin: Marker3D = $GrenadeOrigin
@onready var bullet_origin: Marker3D = $BulletOrigin
@onready var melee_area: Area3D = $Area3D
@onready var animation_player: AnimationPlayer = $Player/AnimationPlayer

@export_category("Statistics")
@export var max_health: int = 500
@export var speed: float = 5.0
@export var rotation_speed: float = 5.0
@export var damage: int = 10

@export_category("Attacks")
@export var grenade_scene: PackedScene
@export var bullet_scene: PackedScene

@export_category("Attack")
@export var attack_speed: float = 1.0
@export var melee_attack_cooldown: float = 0.5
@export var bullet_attack_cooldown: float = 0.2
@export var grenade_attack_cooldown: float = 1.0

@export_category("Sound")
@export var melee_attack_sounds: Array[AudioStream] = []
@export var damage_taken_sounds: Array[AudioStream] = []
@export var healed_sounds: Array[AudioStream] = []
@export var death_sound: AudioStream = null

var health: int = max_health
var is_dead: bool = false

var mouse_world_position: Vector3 = Vector3.ZERO

var melee_attack_timer: float = 0.0
var bullet_attack_timer: float = 0.0
var grenade_attack_timer: float = 0.0


signal death(killed_by: DeathData.KilledBy)

func _ready() -> void:
	animation_player.play("Idling")


func _physics_process(delta: float) -> void:
	if is_dead:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	melee_attack_timer = maxf(melee_attack_timer - delta, 0.0)
	bullet_attack_timer = maxf(bullet_attack_timer - delta, 0.0)
	grenade_attack_timer = maxf(grenade_attack_timer - delta, 0.0)

	var input_dir: Vector2 = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	var direction: Vector3 = Vector3(
		input_dir.x,
		0,
		input_dir.y
	).normalized()

	update_mouse_world_position()
	handle_movement(direction)
	handle_rotation(delta)
	move_and_slide()

	handle_animation(direction)

	handle_melee_attack()
	handle_grenade()
	handle_bullet()


func heal(heal_amount: int) -> void:
	health += heal_amount
	play_random_sound(audio_heal_player, healed_sounds)
	if health > max_health:
		health = max_health


func player_take_damage(damage_amount: int, p_killed_by: DeathData.KilledBy) -> void:
	health -= damage_amount
	play_random_sound(audio_damage_taken_player, damage_taken_sounds)
	if health <= 0:
		health = 0
		is_dead = true
		kill(p_killed_by)


func kill(p_killed_by: DeathData.KilledBy) -> void:
	animation_player.play("DEATH")
	death.emit(p_killed_by)


func apply_bonus(bonus_data: BonusData) -> void:
	match bonus_data.type:
		BonusData.BonusType.DAMAGE:
			damage += int(bonus_data.value)

		BonusData.BonusType.MOVE_SPEED:
			speed += bonus_data.value

		BonusData.BonusType.ATTACK_SPEED:
			attack_speed += bonus_data.value

		BonusData.BonusType.MAX_HEALTH:
			max_health += int(bonus_data.value)
			health += int(bonus_data.value)


func handle_movement(direction: Vector3) -> void:
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)


func handle_animation(direction: Vector3) -> void:
	if is_dead:
		return

	# Ne pas interrompre l'animation d'attaque
	if animation_player.current_animation == "Attack":
		if animation_player.is_playing():
			return

	if direction == Vector3.ZERO:
		animation_player.play("Idling")
		return

	var local_direction: Vector3 = global_transform.basis.inverse() * direction

	if abs(local_direction.z) > abs(local_direction.x):
		if local_direction.z < 0:
			animation_player.play("Run_Forward")
		else:
			animation_player.play("Run_Backwards")
	else:
		if local_direction.x < 0:
			animation_player.play("Run_Left")
		else:
			animation_player.play("Run_Right")


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
	var direction: Vector3 = (
		mouse_world_position - position
	).normalized()

	var target_angle: float = atan2(
		-direction.x,
		-direction.z
	)

	rotation.y = lerp_angle(
		rotation.y,
		target_angle,
		rotation_speed * delta
	)


func handle_grenade() -> void:
	if not Input.is_action_just_pressed("throw_grenade"):
		return

	if grenade_attack_timer > 0.0:
		return

	var grenade: Node3D = grenade_scene.instantiate()

	get_tree().root.add_child(grenade)

	grenade.global_position = grenade_origin.global_position
	grenade.global_rotation = global_rotation

	grenade.throw()
	grenade.add_to_group("projectiles")

	grenade_attack_timer = grenade_attack_cooldown / attack_speed

	animation_player.play("Attack")


func handle_bullet() -> void:
	if not Input.is_action_just_pressed("range_attack"):
		return

	if bullet_attack_timer > 0.0:
		return

	var bullet: Bullet = bullet_scene.instantiate()

	get_tree().root.add_child(bullet)

	bullet.global_transform = bullet_origin.global_transform
	bullet.add_to_group("projectiles")

	bullet_attack_timer = bullet_attack_cooldown / attack_speed

	animation_player.play("Attack")


func handle_melee_attack() -> void:
	if not Input.is_action_just_pressed("melee_attack"):
		return

	if melee_attack_timer > 0.0:
		return

	var targets = melee_area.get_overlapping_bodies()

	play_random_sound(audio_attack_player, melee_attack_sounds)

	for target in targets:
		if target.has_method("take_damage"):
			target.take_damage(
				damage,
				(target.position - position).normalized()
			)

	melee_attack_timer = melee_attack_cooldown / attack_speed

	animation_player.play("Attack")
	
func play_random_sound(audio_player: AudioStreamPlayer3D, sounds: Array[AudioStream]) -> void:
	if sounds.is_empty():
		return
	audio_player.stream = sounds.pick_random()
	audio_player.play()
