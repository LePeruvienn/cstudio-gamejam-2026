extends CharacterBody3D

class_name Enemy

@onready var body_mesh: MeshInstance3D = $Body
@onready var progress_bar: ProgressBar = $SubViewport/ProgressBar

@export var max_health: int = 50
@export var speed: float = 3.0
@export var rotation_speed: float = 5.0

var player: Node3D = null
var health: int = max_health
var is_dead: bool = false

func initialize(start_position: Vector3, player_instance: Node3D):
	player = player_instance
	position = start_position
	look_at_from_position(start_position, player.position, Vector3.UP)

func _ready() -> void:
	update_progress_bar()

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	handle_movement(delta)
	
func handle_movement(delta: float) -> void:
	print("THIS IS THE DEFAULT MOVE!!!")
	
func rotate_towards_player(delta: float) -> void:
	var direction: Vector3 = (player.position - position).normalized()
	var target_angle: float = atan2(-direction.x, -direction.z)
	rotation.y = lerp_angle(rotation.y, target_angle, rotation_speed * delta)

func move_towards_player(delta: float) -> void:
	var direction: Vector3 = (player.position - position).normalized()
	var target_angle: float = atan2(-direction.x, -direction.z)
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	move_and_slide()

func take_damage(amount: int) -> void:
	health -= amount
	update_progress_bar()
	print("losee damage")
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
