extends Node3D

@export var smooth_speed: float = 5.0

@onready var player: Node3D = %Player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = global_position.lerp(player.position, smooth_speed * delta)
