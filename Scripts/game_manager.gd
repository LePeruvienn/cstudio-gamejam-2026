extends Node3D
class_name GameManager

@onready var music_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"
@onready var canva_layer: CanvasLayer = $"../CanvasLayer"
@onready var transition_mananger: Transition = $"../TransitionLayer/TransitionManager"
@onready var enemy_spawner: EnemySpawner = $"../EnemySpawner"
@onready var location_manager: LocationManager = $"../LocationManager"
@onready var fog_manager: FogManager = $"../FogManager"

@export_category("Scenes")
@export var menu_scene: PackedScene
@export var player_hud_scene: PackedScene
@export var choose_contract_scene: PackedScene
@export var looser_scene: PackedScene
@export var player_scene: PackedScene

@export_category("Musics")
@export var ambient_wind_sound: AudioStream
@export var music_fight_sound: AudioStream

var menu_scene_instance: Menu = null
var player_hud_instance: PlayerHUD = null
var choose_contract_instance: DeathChooser = null
var player_instance: Player = null
var looser_screen_instance: LooserScreen = null

var round_counter: int = 0
var current_contract: DeathData = null
var current_death_data: DeathData = null
var current_bonus: BonusData = null

func _ready() -> void:
	start_game()

func start_game() -> void:
	enemy_spawner.set_active(false)
	music_stream_player.stream = ambient_wind_sound
	music_stream_player.play()
	open_menu()

func open_menu() -> void:
	menu_scene_instance = menu_scene.instantiate()
	canva_layer.add_child(menu_scene_instance)
	await menu_scene_instance.pressed_play
	transition_mananger.make_transition(open_choose_contrat)

func open_choose_contrat() -> void:
	
	# Clearing UI
	if looser_screen_instance != null:
		looser_screen_instance.queue_free()
		looser_screen_instance = null
	
	if menu_scene_instance != null:
		menu_scene_instance.queue_free()
		menu_scene_instance = null
	
	choose_contract_instance = choose_contract_scene.instantiate()
	canva_layer.add_child(choose_contract_instance)
	var result: Array = await choose_contract_instance.choosed_contract
	current_contract = result[0]
	current_bonus = result[1]
	print(result)
	print(current_contract)
	transition_mananger.make_transition(start_round)
	
func start_round() -> void:
	
	# Cleaning UI
	choose_contract_instance.queue_free()
	choose_contract_instance = null
	
	music_stream_player.stream = music_fight_sound
	music_stream_player.play()
	player_hud_instance = player_hud_scene.instantiate()
	canva_layer.add_child(player_hud_instance)
	
	player_instance = player_scene.instantiate()
	get_tree().root.add_child(player_instance)
	player_instance.apply_bonus(current_bonus)
	enemy_spawner.set_active(true)
	player_hud_instance.show_clock_quarter(current_contract.clock_state)
	player_hud_instance.set_killed_by(current_contract.killed_by)
	# Wait player to die, and then get all the data
	var s_killed_by: DeathData.KilledBy = await player_instance.death
	var death_data: DeathData = DeathData.new(
		s_killed_by,
		location_manager.get_current_location(player_instance),
		player_hud_instance.clock.get_current_quarter()
	)
	# GOTO End Round Screen
	current_death_data = death_data
	transition_mananger.make_transition(show_looser_screen)
	
func show_looser_screen():
	
	# Clearing map & UI
	enemy_spawner.set_active(false)
	enemy_spawner.kill_all_enemies()
	player_hud_instance.queue_free()
	player_hud_instance = null
	player_instance.queue_free()
	player_instance = null
	
	music_stream_player.stream = ambient_wind_sound
	music_stream_player.play()
	looser_screen_instance = looser_scene.instantiate()
	canva_layer.add_child(looser_screen_instance)
	looser_screen_instance.initialize(current_death_data, current_contract)
	# Waiting to press continue
	var is_round_won: bool = await looser_screen_instance.continue_game
	# Managing win
	if is_round_won:
		round_counter += 1
		transition_mananger.make_transition(open_choose_contrat)
	else:
		round_counter = 0
		transition_mananger.make_transition(open_menu)
