extends Control
class_name DeathChooser
	
@onready var contracts_ui: Array[ContractItemUI] = [
	$HBoxContainer/DeathContractInterface,
	$HBoxContainer/DeathContractInterface2,
	$HBoxContainer/DeathContractInterface3
]
	
var contracts: Array[DeathData] = []
var bonuses: Array[BonusData] = []

signal choosed_contract(contract: DeathData, bonus: BonusData)

func _ready() -> void:
	contracts.push_back(DeathData.create_random())
	contracts.push_back(DeathData.create_random())
	contracts.push_back(DeathData.create_random())
	bonuses.push_back(BonusData.create_random())
	bonuses.push_back(BonusData.create_random())
	bonuses.push_back(BonusData.create_random())
	update_ui()
	
func update_ui() -> void:
	for i in range(0, 3):
		var contract_ui: ContractItemUI = contracts_ui[i]
		contract_ui.set_data(contracts[i], bonuses[i])
		
func on_contract_choosed(p_contract: DeathData, p_bonus: BonusData) -> void:
	choosed_contract.emit(p_contract, p_bonus)
	print("TEST!!", p_bonus)

func _on_death_contract_interface_choice_made(contract: DeathData, bonus: BonusData) -> void:
	on_contract_choosed(contract, bonus)
func _on_death_contract_interface_2_choice_made(contract: DeathData, bonus: BonusData) -> void:
	on_contract_choosed(contract, bonus)
func _on_death_contract_interface_3_choice_made(contract: DeathData, bonus: BonusData) -> void:
	on_contract_choosed(contract, bonus)
