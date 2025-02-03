extends Node

const signals = {
	"on_attack_hit": {
		"function_name": "handleAttack",
		"link_type": "opposite"
	},
	"on_attack_blocked": {
		"function_name": "handleAttackBlocked",
		"link_type": "opposite"
	},
	"on_parade": {
		"function_name": "handleParade",
		"link_type": "opposite"
	},
	"on_charge_medium": {
		"function_name": "handleChargeMedium",
		"link_type": "same"
	},
	"on_charge_strong": {
		"function_name": "handleChargeStrong",
		"link_type": "same"
	},
	"on_damage_taken": {
		"function_name": "handleDamageTaken",
		"link_type": "same"
	},
	"on_dead": {
		"function_name": "endCombat",
		"link_type": "opposite"
	}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
