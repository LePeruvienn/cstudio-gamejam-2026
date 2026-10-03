extends Node3D

@onready var player: Node3D = %Player

@onready var enemy_spawn_location: PathFollow3D = $SpawnPath/PathFollow3D

@export var enemy_scene: PackedScene

func _on_enemy_timer_timeout() -> void:
	enemy_spawn_location.progress_ratio = randf()
	var start_pos: Vector3 = enemy_spawn_location.position
	var enemy: Node3D = enemy_scene.instantiate()
	enemy.initialize(start_pos, player)
	get_tree().root.add_child(enemy)
