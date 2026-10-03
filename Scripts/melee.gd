class_name MeleeEnemy
extends Enemy

func handle_movement(delta: float) -> void:
	rotate_towards_player(delta)
	move_towards_player(delta)
