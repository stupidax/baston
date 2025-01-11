extends Node

@export var life = 10;
@export var charge_frames = {
	Constants.attack_type.LIGHT: null,
	Constants.attack_type.MEDIUM: 4,
	Constants.attack_type.STRONG: 12
};
@export var charge_frames_cap = 15;
@export var start_up_frames = {
	Constants.attack_type.LIGHT: 3,
	Constants.attack_type.MEDIUM: 5,
	Constants.attack_type.STRONG: 7
};
@export var active_frames = {
	Constants.attack_type.LIGHT: 3,
	Constants.attack_type.MEDIUM: 3,
	Constants.attack_type.STRONG: 4
};
@export var recovery_frames = {
	Constants.attack_type.LIGHT: 5,
	Constants.attack_type.MEDIUM: 10,
	Constants.attack_type.STRONG: 15
};
@export var stun_block_frames = 1;
@export var hit_stun_frames = {
	Constants.attack_type.LIGHT: 6,
	Constants.attack_type.MEDIUM: 9,
	Constants.attack_type.STRONG: 0
};
@export var attack_damage = {
	Constants.attack_type.LIGHT: 1,
	Constants.attack_type.MEDIUM: 2,
	Constants.attack_type.STRONG: 3	
};

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
