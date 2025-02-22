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
	Constants.attack_type.MEDIUM: 90,
	Constants.attack_type.STRONG: 94,
	Constants.key_word.CAP: 96
};
@export var start_up_frames = {
	Constants.attack_type.LIGHT: 20,
	Constants.attack_type.MEDIUM: 42,
	Constants.attack_type.STRONG: 64,
	Constants.key_word.PARADE: 101
};
@export var active_frames = {
	Constants.attack_type.LIGHT: 21,
	Constants.attack_type.MEDIUM: 44,
	Constants.attack_type.STRONG: 65,
	Constants.key_word.PARADE: 103
};
@export var block_stun_frames = {
	Constants.attack_type.LIGHT: 15,
	Constants.attack_type.MEDIUM: 35,
};
@export var hit_stun_frames = {
	Constants.attack_type.LIGHT: 6,
	Constants.attack_type.MEDIUM: 9,
	Constants.attack_type.STRONG: 61
};
@export var counter_frames = 60;
