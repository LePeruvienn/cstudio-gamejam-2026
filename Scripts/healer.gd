extends Enemy
class_name HealerEnemy

@onready var line_origin: Marker3D = $Marker3D
@onready var heal_timer: Timer = $HealTimer
@onready var beam_mesh: Beam = $Beam

@export var heal_range: float = 5.0
@export var heal_amount: int = 10
@export var heal_cooldown: float = 0.5

var can_heal: bool = true

func _ready() -> void:
	$Allie2/AnimationPlayer.play("idle")

func handle_movement(delta: float) -> void:
	rotate_towards_player(delta)
	var distance2: float = position.distance_squared_to(player.position)
	var heal_range2: float = heal_range * heal_range
	if distance2 < heal_range2:
		handle_heal()
		beam_mesh.show()
		var start_position: Vector3 = line_origin.global_position
		var end_position: Vector3 = player.position
		end_position.y += line_origin.position.y
		beam_mesh.update_beam(start_position, end_position)
	else:
		beam_mesh.hide()
		move_towards_player(delta)
		
func handle_heal():
	if can_heal:
		player.heal(heal_amount)
		can_heal = false
		heal_timer.start(heal_cooldown)

func _on_heal_timer_timeout() -> void:
	can_heal = true
