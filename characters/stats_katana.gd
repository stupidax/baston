extends Node

@export_group("Stats data")
@export var life = 10;
@export var shield = 10;
@export var attack_damage = {
	Constants.attack_type.LIGHT: 1,
	Constants.attack_type.MEDIUM: 2,
	Constants.attack_type.STRONG: 3,
	Constants.key_word.COUNTER: 2
};
@export var shield_break = {
	Constants.attack_type.LIGHT: 2,
	Constants.attack_type.MEDIUM: 4,
};

@export_group("Frames data")
@export var charge_frames = {
	Constants.attack_type.MEDIUM: 5,
	Constants.attack_type.STRONG: 22,
	Constants.key_word.CAP: 27
};
@export var start_up_frames = {
	Constants.attack_type.LIGHT: 4,
	Constants.attack_type.MEDIUM: 8,
	Constants.attack_type.STRONG: 9,
	Constants.key_word.PARADE: 0
};
@export var active_frames = {
	Constants.attack_type.LIGHT: 3,
	Constants.attack_type.MEDIUM: 4,
	Constants.attack_type.STRONG: 4,
	Constants.key_word.PARADE: 2
};
@export var recovery_frames = {
	Constants.attack_type.LIGHT: 6,
	Constants.attack_type.MEDIUM: 12,
	Constants.attack_type.STRONG: 17,
	Constants.key_word.PARADE: 0
};
@export var block_stun_frames = {
	Constants.attack_type.LIGHT: 6,
	Constants.attack_type.MEDIUM: 12,
};
@export var hit_stun_frames = {
	Constants.attack_type.LIGHT: 5,
	Constants.attack_type.MEDIUM: 8,
	Constants.attack_type.STRONG: 0
};
@export var counter_frames = 0;
