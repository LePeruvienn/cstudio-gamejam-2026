extends Node3D
class_name EnemySpawner

@onready var game_manager: GameManager = %GameManager
@onready var enemy_spawn_location: PathFollow3D = $SpawnPath/PathFollow3D
@onready var spawn_timer: Timer = $SpawnTimer

@export_category("Spawn Config")
@export var enemy_spawn_configs: Array[EnemySpawnConfig] = []

@export_category("Spawn Difficulty")
@export var initial_spawn_interval: float = 2.0
@export var spawn_interval_decrease: float = 0.2
@export var minimum_spawn_interval: float = 0.3

var is_active: bool = false
var current_spawn_interval: float = initial_spawn_interval

func _ready() -> void:
	current_spawn_interval = initial_spawn_interval

func spawn_more() -> void:
	current_spawn_interval = maxf(
		current_spawn_interval - spawn_interval_decrease,
		minimum_spawn_interval
	)
	spawn_timer.wait_time = current_spawn_interval
	if spawn_timer.is_stopped() == false:
		spawn_timer.start()

func set_active(p_is_active: bool) -> void:
	is_active = p_is_active
	
func kill_all_enemies() -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
	for projectile in get_tree().get_nodes_in_group("projectiles"):
		projectile.queue_free()

func _on_enemy_timer_timeout() -> void:
	if is_active:
		spawn_enemy()

func spawn_enemy() -> void:
	var enemy_position: Vector3 = get_random_position()
	var enemy_scene: PackedScene = get_random_enemy_scene()
	var enemy: Node3D = enemy_scene.instantiate()
	var player: Player = game_manager.player_instance
	enemy.initialize(enemy_position, player)
	get_tree().root.add_child(enemy)
	enemy.add_to_group("enemies")

func get_random_position() -> Vector3:
	enemy_spawn_location.progress_ratio = randf()
	return enemy_spawn_location.position

func get_random_enemy_scene() -> PackedScene:
	var total_chance := 0.0
	for config in enemy_spawn_configs:
		total_chance += config.chance
	var roll := randf_range(0.0, total_chance)
	for config in enemy_spawn_configs:
		roll -= config.chance
		if roll <= 0.0:
			return config.enemy_scene
	return null
	
