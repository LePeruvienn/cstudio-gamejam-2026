extends Node3D

@onready var game_manager: GameManager = %GameManager

@export var smooth_speed: float = 5.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player: Player = game_manager.player_instance
	if is_instance_valid(player):
		position = global_position.lerp(player.position, smooth_speed * delta)
