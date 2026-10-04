extends Enemy
class_name DashEnemy

@onready var attack_area: Area3D = $Area3D
@onready var attack_timer: Timer = $AttackTimer

@export_category("Attack")
@export var damage: int = 10
@export var attack_cooldown: float = 1.5

@export_category("Dash")
@export var dash_speed: float = 20.0
@export var dash_duration: float = 0.25
@export var dash_deceleration: float = 50.0

var can_attack: bool = true
var is_dashing: bool = false
var has_hit_player: bool = false
var dash_timer: float = 0.0
var dash_velocity: Vector3 = Vector3.ZERO


func handle_movement(delta: float) -> void:
	if is_dashing:
		handle_dash(delta)
		return

	rotate_towards_player(delta)

	if can_attack:
		handle_attack()
	else:
		move_towards_player(delta)


func handle_attack() -> void:
	if not can_attack:
		return

	start_dash()


func start_dash() -> void:
	if not is_instance_valid(player):
		return

	is_dashing = true
	can_attack = false
	has_hit_player = false
	dash_timer = dash_duration

	var direction := global_position.direction_to(player.global_position)

	dash_velocity = direction * dash_speed

	attack_timer.start(attack_cooldown)


func handle_dash(delta: float) -> void:
	dash_timer -= delta

	# Ralentissement progressif
	dash_velocity = dash_velocity.move_toward(
		Vector3.ZERO,
		dash_deceleration * delta
	)

	velocity.x = dash_velocity.x
	velocity.z = dash_velocity.z

	handle_attack_collision()

	if dash_timer <= 0.0:
		end_dash()


func end_dash() -> void:
	is_dashing = false
	dash_velocity = Vector3.ZERO
	velocity.x = 0.0
	velocity.z = 0.0


func handle_attack_collision() -> void:
	if has_hit_player:
		return

	for target in attack_area.get_overlapping_bodies():
		if target.has_method("player_take_damage"):
			target.player_take_damage(
				damage,
				DeathData.KilledBy.ENEMY_MELEE
			)

			has_hit_player = true
			return


func _on_attack_timer_timeout() -> void:
	can_attack = true
