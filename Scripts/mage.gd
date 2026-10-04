extends Enemy
class_name MageEnemy

@onready var animation_player: AnimationPlayer = $Lancier/AnimationPlayer
@onready var projectile_origin: Marker3D = $Marker3D
@onready var attack_timer: Timer = $AttackTimer

@export var attack_range: float = 5.0
@export var attack_damage: int = 10
@export var attack_cooldown: float = 0.5
@export var projectile_scene: PackedScene
@export var projectile_speed: float = 10.0

var can_attack: bool = true

func handle_movement(delta: float) -> void:
	rotate_towards_player(delta)
	var distance2: float = position.distance_squared_to(player.position)
	var attack_range2: float = attack_range * attack_range
	if distance2 < attack_range2:
		handle_attack()
	else:
		play_animation("Running")
		move_towards_player(delta)
		
func handle_attack() -> void:
	if not can_attack:
		return
	play_animation("Throw")
	spawn_projectile()
	can_attack = false
	attack_timer.start(attack_cooldown)
		
func _on_attack_timer_timeout() -> void:
	can_attack = true
	
func spawn_projectile() -> void:
	var projectile: Projectile = projectile_scene.instantiate()
	get_tree().root.add_child(projectile)
	projectile.global_position = projectile_origin.global_position
	projectile.initialize(player, projectile_speed, attack_damage)
	projectile.add_to_group("projectiles")


func play_animation(animation_name: StringName) -> void:
	if animation_player.current_animation == animation_name:
		return
	animation_player.play(animation_name)
