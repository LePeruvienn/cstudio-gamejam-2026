extends Enemy
class_name Slasher

@onready var animation_player: AnimationPlayer = $dino/AnimationPlayer
@onready var attack_area: Area3D = $Area3D
@onready var attack_timer: Timer = $AttackTimer

@export_category("Attack")
@export var damage: int = 10
@export var attack_cooldown: float = 1.5
@export var attack_range: float = 8.0

@export_category("Dash")
@export var dash_speed: float = 20.0
@export var dash_duration: float = 1.5
@export var dash_deceleration: float = 50.0

var can_attack: bool = true
var is_dashing: bool = false
var has_hit_player: bool = false

var dash_timer: float = 0.0
var dash_velocity: Vector3 = Vector3.ZERO
var dash_direction: Vector3 = Vector3.ZERO


func handle_movement(delta: float) -> void:
	rotate_towards_player(delta)
	if is_dashing:
		handle_dash(delta)
		return
	var distance2 := global_position.distance_squared_to(
		player.global_position
	)

	if distance2 <= attack_range * attack_range:
		handle_attack()
	else:
		play_animation("Run")
		move_towards_player(delta)


func handle_attack() -> void:
	if not can_attack:
		return
	start_dash()


func start_dash() -> void:
	if not is_instance_valid(player):
		return

	can_attack = false
	is_dashing = true
	has_hit_player = false

	dash_timer = dash_duration

	# Capture the direction ONCE.
	dash_direction = global_position.direction_to(
		player.global_position
	)

	dash_velocity = dash_direction * dash_speed

	attack_timer.start(attack_cooldown)

	# Animation
	# animation_player.play("dash")


func handle_dash(delta: float) -> void:
	dash_timer -= delta

	# Slow down progressively.
	dash_velocity = dash_velocity.move_toward(
		Vector3.ZERO,
		dash_deceleration * delta
	)

	velocity.x = dash_velocity.x
	velocity.z = dash_velocity.z

	play_animation("Charge")
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
				DeathData.KilledBy.ENEMY_SLASHER
			)
			has_hit_player = true
			return

func _on_attack_timer_timeout() -> void:
	can_attack = true
	
func play_animation(animation_name: StringName) -> void:
	if animation_player.current_animation == animation_name:
		return
	animation_player.play(animation_name)
