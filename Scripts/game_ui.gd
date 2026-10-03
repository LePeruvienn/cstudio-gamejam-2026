extends CanvasLayer

@onready var player: Node3D = %Player
@onready var player_hud: PlayerHUD = $PlayerHUD

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_player_hud()
		
	
func update_player_hud():	
	if not is_instance_valid(player):
		return
	player_hud.set_life_bar(player.health, player.max_health)
