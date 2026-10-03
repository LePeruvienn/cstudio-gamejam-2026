extends Enemy
class_name MeleeEnemy

@onready var attack_area: Area3D = $Area3D
@onready var attack_timer: Timer = $AttackTimer

@export var damage: int = 10
@export var attack_cooldown: float = 0.5

var can_attack: bool = true

func handle_movement(delta: float) -> void:
	rotate_towards_player(delta)
	move_towards_player(delta)
	handle_attack()
	
func handle_attack() -> void:
	if can_attack:
		make_attack()
		can_attack = false
		attack_timer.start(attack_cooldown)
			
func make_attack() -> void:
	var targets = attack_area.get_overlapping_bodies()
	for target in targets:
		if target.has_method("take_damage"):
			target.take_damage(damage)
			
func _on_attack_timer_timeout() -> void:
	can_attack = true
