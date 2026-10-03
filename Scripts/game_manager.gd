extends Node3D

@onready var canva_layer: CanvasLayer = $HUD
@onready var enemy_spawner: EnemySpawner = $EnemySpawner

@export var player_hud_scene: PackedScene
@export var choose_contract_scene: PackedScene
@export var looser_scene: PackedScene

@export var player_scene: PackedScene

var player_hud_instance: Node3D = null
var choose_contract_instance: Node3D = null
var player_instance: Node3D = null

enum GameState
{
	CHOOSING_CONTRACT,
	GAMING,
	LOOSING
}

var current_contract: DeathData = null

func _ready() -> void:
	start_game()

func start_game() -> void:
	open_choose_contrat();

func open_choose_contrat() -> void:
	choose_contract_instance =  choose_contract_scene.instantiate()
	canva_layer.add_child(choose_contract_instance)
	
func start_round() -> void:
	pass
