extends Control
class_name DeathChooser
	
@onready var contracts_ui: Array[ContractItemUI] = [
	$HBoxContainer/DeathContractInterface,
	$HBoxContainer/DeathContractInterface2,
	$HBoxContainer/DeathContractInterface3
]
	
var contracts: Array[DeathData] = []

func _ready() -> void:
	contracts.push_back(DeathData.create_random())
	contracts.push_back(DeathData.create_random())
	contracts.push_back(DeathData.create_random())
	update_ui()
	
func update_ui() -> void:
	for i in range(0, 3):
		var contract_ui: ContractItemUI = contracts_ui[i]
		contract_ui.set_from_death_condition(contracts[i])
