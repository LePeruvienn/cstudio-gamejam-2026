extends Control
class_name DeathChooser
	
@onready var contracts_ui: Array[ContractItemUI] = [
	$HBoxContainer/DeathContractInterface,
	$HBoxContainer/DeathContractInterface2,
	$HBoxContainer/DeathContractInterface3
]
	
var contracts: Array[DeathData] = []

signal choosed_contract(contract: DeathData)

func _ready() -> void:
	contracts.push_back(DeathData.create_random())
	contracts.push_back(DeathData.create_random())
	contracts.push_back(DeathData.create_random())
	update_ui()
	
func update_ui() -> void:
	for i in range(0, 3):
		var contract_ui: ContractItemUI = contracts_ui[i]
		contract_ui.set_from_death_condition(contracts[i])
		
func on_contract_choosed(p_contract: DeathData) -> void:
	choosed_contract.emit(p_contract)
		
func _on_death_contract_interface_choice_made(contract: DeathData) -> void:
	on_contract_choosed(contract)
func _on_death_contract_interface_2_choice_made(contract: DeathData) -> void:
	on_contract_choosed(contract)
func _on_death_contract_interface_3_choice_made(contract: DeathData) -> void:
	on_contract_choosed(contract)
