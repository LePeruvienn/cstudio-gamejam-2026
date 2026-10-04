extends CharacterBody3D

class_name Enemy

@onready var body_mesh: MeshInstance3D = $Body
@onready var progress_bar: ProgressBar = $SubViewport/ProgressBar

@export_category("Statistics")
@export var max_health: int = 50
@export var speed: float = 3.0
@export var rotation_speed: float = 5.0

@export_category("Knockback")
@export var knockback_force: float = 10.0
@export var knockback_friction: float = 30.0

var player: Player = null
var health: int = max_health
var is_dead: bool = false

var knockback_velocity: Vector3 = Vector3.ZERO

func initialize(start_position: Vector3, player_instance: Player):
	player = player_instance
	position = start_position
	look_at_from_position(start_position, player.position, Vector3.UP)

func _ready() -> void:
	update_progress_bar()

func _physics_process(delta: float) -> void:
	velocity.x = 0.0
	velocity.z = 0.0
	if is_dead:
		return
	handle_movement(delta)
	# Knockback
	knockback_velocity = knockback_velocity.move_toward(
		Vector3.ZERO,
		knockback_friction * delta
	)
	velocity += knockback_velocity
	move_and_slide()
	
func handle_movement(delta: float) -> void:
	print("THIS IS THE DEFAULT MOVE!!!")
	
func rotate_towards_player(delta: float) -> void:
	if not is_instance_valid(player):
		return
	var direction: Vector3 = (player.position - position).normalized()
	var target_angle: float = atan2(-direction.x, -direction.z)
	rotation.y = lerp_angle(rotation.y, target_angle, rotation_speed * delta)

func move_towards_player(delta: float) -> void:
	if not is_instance_valid(player):
		return
	var direction: Vector3 = (player.position - position).normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

func take_damage(amount: int, knockback_direction: Vector3 = Vector3.ZERO) -> void:
	health -= amount
	knockback_direction.y = 0
	if knockback_direction != Vector3.ZERO:
		knockback_velocity = (knockback_direction.normalized() * knockback_force)
	update_progress_bar()
	if health <= 0:
		health = 0
		die()
		
func die() -> void:
	is_dead = true
	queue_free()
	
func update_progress_bar() -> void:
	progress_bar.max_value = max_health
	progress_bar.value = health

# DIFFERENT COMPORTEMENT DES ENEMIES  
