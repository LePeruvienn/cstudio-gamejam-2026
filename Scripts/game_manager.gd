extends Node3D
class_name GameManager

@onready var canva_layer: CanvasLayer = $"../HUD"
@onready var enemy_spawner: EnemySpawner = $"../EnemySpawner"
@onready var location_manager: LocationManager = $"../LocationManager"

@export var player_hud_scene: PackedScene
@export var choose_contract_scene: PackedScene
@export var looser_scene: PackedScene
@export var player_scene: PackedScene

var player_hud_instance: PlayerHUD = null
var choose_contract_instance: DeathChooser = null
var player_instance: Player = null
var looser_screen_instance: LooserScreen = null

var round_counter: int = 0
var current_contract: DeathData = null

func _ready() -> void:
	start_game()

func start_game() -> void:
	enemy_spawner.set_active(false)
	open_choose_contrat();

func open_choose_contrat() -> void:
	choose_contract_instance = choose_contract_scene.instantiate()
	canva_layer.add_child(choose_contract_instance)
	current_contract = await choose_contract_instance.choosed_contract
	print(current_contract)
	choose_contract_instance.queue_free()
	choose_contract_instance = null
	start_round()
	
func start_round() -> void:
	player_hud_instance = player_hud_scene.instantiate()
	canva_layer.add_child(player_hud_instance)
	
	player_instance = player_scene.instantiate()
	get_tree().root.add_child(player_instance)
	
	enemy_spawner.set_active(true)
	player_hud_instance.show_clock_quarter(current_contract.clock_state)
	# Wait player to die, and then get all the data
	var s_killed_by: DeathData.KilledBy = await player_instance.death
	var death_data: DeathData = DeathData.new(
		s_killed_by,
		location_manager.get_current_location(player_instance),
		player_hud_instance.clock.get_current_quarter()
	)
	# Clearing map & UI
	enemy_spawner.set_active(false)
	enemy_spawner.kill_all_enemies()
	player_hud_instance.queue_free()
	player_hud_instance = null
	player_instance.queue_free()
	player_instance = null
	# GOTO End Round Screen
	show_looser_screen(death_data)
	
func show_looser_screen(death_data: DeathData):
	looser_screen_instance = looser_scene.instantiate()
	canva_layer.add_child(looser_screen_instance)
	looser_screen_instance.initialize(death_data, current_contract)
	# Waiting to press continue
	var is_round_won: bool = await looser_screen_instance.continue_game
	# Clearing UI
	looser_screen_instance.queue_free()
	looser_screen_instance = null
	# Managing win
	if is_round_won:
		round_counter += 1
	else:
		round_counter = 0
	# Continue
	open_choose_contrat()
