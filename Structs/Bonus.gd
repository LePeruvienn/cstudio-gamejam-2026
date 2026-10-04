class_name BonusData
extends RefCounted

enum BonusType {
	DAMAGE,
	MOVE_SPEED,
	ATTACK_SPEED,
	MAX_HEALTH
}

const BONUS_NAMES := {
	BonusType.DAMAGE: "Dégats",
	BonusType.MOVE_SPEED: "Vitesse",
	BonusType.ATTACK_SPEED: "Vitesse d'attaque",
	BonusType.MAX_HEALTH: "PV Max",
}

const DAMAGE_MIN: float = 5.0
const DAMAGE_MAX: float = 20.0

const MOVE_SPEED_MIN: float = 0.5
const MOVE_SPEED_MAX: float = 3.0

const ATTACK_SPEED_MIN: float = 0.05
const ATTACK_SPEED_MAX: float = 0.3

const MAX_HEALTH_MIN: float = 25.0
const MAX_HEALTH_MAX: float = 100.0

var type: BonusType
var value: float

func _init(p_type: BonusType, p_value: float) -> void:
	type = p_type
	value = p_value

static func create_random() -> BonusData:
	var type: BonusType = BonusType.values().pick_random()
	var value: float = 0.0
	match type:
		BonusType.DAMAGE:
			value = randf_range(DAMAGE_MIN, DAMAGE_MAX)
		BonusType.MOVE_SPEED:
			value = randf_range(MOVE_SPEED_MIN, MOVE_SPEED_MAX)
		BonusType.ATTACK_SPEED:
			value = randf_range(ATTACK_SPEED_MIN, ATTACK_SPEED_MAX)
		BonusType.MAX_HEALTH:
			value = randf_range(MAX_HEALTH_MIN, MAX_HEALTH_MAX)
	return BonusData.new(type, value)
