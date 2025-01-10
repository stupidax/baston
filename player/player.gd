extends Node2D

const Animations = {
	"ATTACK": "charge", 
	"BLOCK": "block", 
	"COUNTER": "counter", 
	"DEAD": "dead", 
	"HIT": "hit", 
	"IDLE": "idle", 
	"PARADE": "parade",
	"VICTORY": "victory"
}

enum attack_type {SIMPLE, CHARGED, IMPARABLE}
const SIMPLE_DAMAGE = 1;
const STRONG_CHARGE_NEEDED = 14;
const STRONG_DAMAGE = 2;
const IMPARABLE_CHARGE_NEEDED = 28;
const IMPARABLE_DAMAGE = 3;
func from_frame_to_attack_type(frame_number):
	if frame_number >= IMPARABLE_CHARGE_NEEDED:
		return attack_type.IMPARABLE;
	elif frame_number >= STRONG_CHARGE_NEEDED:
		return attack_type.CHARGED;
	return attack_type.SIMPLE;
	
class Player:
	const DEFAULT_LIFE = 10;
	const MAX_CHARGE = 30;
	
	var is_combat_ongoing;
	var life;
	var sprite;
	var attack_action;
	var block_action;
	var current_animation;
	var charge_frames;
	var is_charging;
	var current_attack_type = attack_type.SIMPLE;
	
	var on_attack;
	var on_parade;
	var on_block;
	
	func _init(life_param, sprite_param, attack_action_param, \
		block_action_param, attack_signal, parade_signal, block_signal):
		
		self.life = life_param;
		self.sprite = sprite_param;
		self.attack_action = attack_action_param;
		self.block_action = block_action_param;
		self.set_current_animation(Animations.IDLE);
		self.charge_frames = 0;
		self.is_charging = false;
		self.is_combat_ongoing = false;
		
		self.on_attack = attack_signal;
		self.on_parade = parade_signal;
		self.on_block = block_signal;
	
	func set_current_animation(new_animation):
		self.current_animation = new_animation;
		self.sprite.play(new_animation);
	func is_action_allowed() -> bool:
		return self.current_animation == Animations.IDLE \
			|| self.current_animation == Animations.DEAD \
			|| self.current_animation == Animations.BLOCK \
			|| self.current_animation == Animations.PARADE \
			|| self.current_animation == Animations.COUNTER \
			|| self.current_animation == Animations.HIT;
	
	func compute_charge():
		if self.is_charging:
			self.increment_charge_frames();
		else:
			self.reset_charge_frames();
			
		if self.is_max_charge():
			self.current_attack_type = attack_type.IMPARABLE;
			self.sprite.play();
			self.is_charging = false;
			self.reset_charge_frames();
	func increment_charge_frames():
		self.charge_frames += 1;
	func reset_charge_frames():
		self.charge_frames = 0;
	func is_max_charge():
		return self.charge_frames == MAX_CHARGE;
	
	func compute_received_attack(attack_received) -> int:
		var is_hit = false;
		var damage = 0;
		if attack_received == attack_type.IMPARABLE:
			damage = IMPARABLE_DAMAGE;
			is_hit = true;
		elif self.current_animation == Animations.PARADE:
			self.on_parade.emit();
		elif self.current_animation == Animations.BLOCK:
			self.on_block.emit();
		elif attack_received == attack_type.CHARGED:
			damage = STRONG_DAMAGE;
			is_hit = true;
		else:
			damage = SIMPLE_DAMAGE;
			is_hit = true;
		
		self.life -= damage;
		
		if self.is_dead():
			self.set_current_animation(Animations.DEAD);
		elif is_hit:
			self.set_current_animation(Animations.HIT);
		
		return damage;
				
	func is_dead() -> bool:
		return self.life < 1;

@export var player_life: int = Player.DEFAULT_LIFE;
@export var player_attack: String;
@export var player_block: String;

func attack_received(attack_type) -> void:
	var damage = player.compute_received_attack(attack_type);
	if damage:
		on_damage_taken.emit(damage);
	if player.is_dead():
		player.is_combat_ongoing = false;
		on_dead.emit();
	
func parade_received() -> void:
	player.set_current_animation(Animations.COUNTER);
	
func win_combat() -> void:
	player.is_combat_ongoing = false;
	player.set_current_animation(Animations.VICTORY);

signal on_attack();
signal on_parade();
signal on_block();
signal on_damage_taken();
signal on_dead();

var player;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = Player.new(player_life, $AnimatedSprite2D, player_attack, player_block, on_attack, on_parade, on_block);
	$AnimatedSprite2D.frame_changed.connect(_animation_progress.bind($AnimatedSprite2D));
	$AnimatedSprite2D.animation_finished.connect(_animation_end.bind($AnimatedSprite2D));
	player.is_combat_ongoing = true;

func _animation_progress(sprite) -> void:
	if sprite.animation == Animations.ATTACK && sprite.is_playing() && sprite.frame == 4 && Input.is_action_pressed(player.attack_action):
		sprite.pause();
		player.is_charging = true;
	if sprite.animation == Animations.ATTACK && sprite.is_playing() && sprite.frame == 7:
		player.on_attack.emit(player.current_attack_type);

func _animation_end(sprite) -> void:
	if sprite.animation == Animations.VICTORY:
		sprite.set_frame_and_progress(2, 0.0);
		sprite.play();
	elif sprite.animation == Animations.PARADE:
		player.set_current_animation(Animations.BLOCK);	
	elif sprite.animation != Animations.DEAD && sprite.animation != Animations.IDLE:
		player.set_current_animation(Animations.IDLE);

func _input(event) -> void:
	if !player.is_combat_ongoing:
		return;
	
	if event.is_action_released(player.attack_action):
		player.current_attack_type = from_frame_to_attack_type(player.charge_frames);
		$AnimatedSprite2D.play();
		player.is_charging = false;
		player.reset_charge_frames();
		
	if event.is_action_released(player.block_action):
		player.set_current_animation(Animations.IDLE);
	
	if !player.is_action_allowed():
		return;
	
	if event.is_action_pressed(player.attack_action):
		player.set_current_animation(Animations.ATTACK);
	if event.is_action_pressed(player.block_action):
		player.set_current_animation(Animations.PARADE);

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(_delta: float) -> void:
	player.compute_charge();
	if player.is_dead():
		player.set_current_animation(Animations.DEAD);
		
	if player.is_charging:
		player.increment_charge_frames();
	else:
		player.reset_charge_frames();
		
	if player.is_max_charge():
		$AnimatedSprite2D.play();
		player.is_charging = false;
		player.reset_charge_frames();
