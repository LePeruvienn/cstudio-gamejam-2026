extends Node3D

@onready var player: Node3D = %Player
@onready var enemy_spawn_location: PathFollow3D = $SpawnPath/PathFollow3D

@export var enemy_spawn_configs: Array[EnemySpawnConfig] = []

func _on_enemy_timer_timeout() -> void:
	spawn_enemy()
	
func spawn_enemy() -> void:
	var position: Vector3 = get_random_position()
	var enemy_scene: PackedScene = get_random_enemy_scene()
	var enemy: Node3D = enemy_scene.instantiate()
	enemy.initialize(position, player)
	get_tree().root.add_child(enemy)

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
	
