extends Node2D

const Animations = {
	"ATTACK_LIGHT": "attack_light",
	"ATTACK_MEDIUM": "attack_medium", 
	"ATTACK_STRONG": "attack_strong", 
	"BLOCK": "block", 
	"CHARGE": "charge",
	"COUNTER": "counter", 
	"DEAD": "dead", 
	"HIT": "hit", 
	"IDLE": "idle", 
	"PARADE": "parade",
	"VICTORY": "victory"
}

func from_frame_to_attack_type(frame_number):
	if frame_number >= player_stats.charge_frames[Constants.attack_type.STRONG]:
		return Constants.attack_type.STRONG;
	elif frame_number >= player_stats.charge_frames[Constants.attack_type.MEDIUM]:
		return Constants.attack_type.MEDIUM;
	return Constants.attack_type.LIGHT;
	
class Player:
	var is_combat_ongoing;
	var life: int;
	var charge;
	var max_charge;
	var damage;
	var sprite;
	var attack_action;
	var block_action;
	var current_animation;
	var charge_frames: int;
	var stun_frames: int;
	var stun_block_frames: int;
	var is_charging;
	var current_attack_type;
	
	var on_attack;
	var on_parade;
	var on_block;
	
	func _init(stats_param, sprite_param, attack_action_param, block_action_param, \
		attack_signal, charge_medium_signal, charge_strong_signal, parade_signal, block_signal):
		
		self.life = stats_param.life;
		self.charge = {
			stats_param.charge_frames[Constants.attack_type.MEDIUM]: charge_medium_signal,
			stats_param.charge_frames[Constants.attack_type.STRONG]: charge_strong_signal
		};
		self.max_charge = stats_param.charge_frames_cap;
		# TODO: loop instead
		self.damage = stats_param.attack_damage;
		
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
		return !self.is_stunned() \
			|| self.current_animation == Animations.IDLE \
			|| self.current_animation == Animations.DEAD \
			|| self.current_animation == Animations.BLOCK \
			|| self.current_animation == Animations.PARADE \
			|| self.current_animation == Animations.COUNTER \
			|| self.current_animation == Animations.HIT;
	
	func compute_stun_block():
		if !self.is_block_available():
			self.stun_block_frames -= 1;
	func compute_stun():
		if self.is_stunned:
			self.stun_frames -= 1;	
	func compute_charge():
		if self.is_charging:
			self.increment_charge_frames();
		else:
			self.reset_charge_frames();
			
		if self.is_max_charge():
			self.current_attack_type = Constants.attack_type.STRONG;
			self.sprite.play(Animations.ATTACK_STRONG);
			self.is_charging = false;
			self.reset_charge_frames();
	func increment_charge_frames():
		self.charge_frames += 1;
		if self.charge.has(self.charge_frames):
			self.charge[self.charge_frames].emit();
	func reset_charge_frames():
		self.charge_frames = 0;
	func is_max_charge():
		return self.charge_frames == self.max_charge;
	
	func compute_received_attack(attack_received) -> int:
		var is_hit = false;
		var damage = 0;
		if attack_received != Constants.attack_type.STRONG && self.current_animation == Animations.PARADE:
			self.on_parade.emit();
		elif attack_received != Constants.attack_type.STRONG && self.current_animation == Animations.BLOCK:
			self.on_block.emit();
		else:
			damage = self.damage[attack_received];
			is_hit = true;
		
		self.life -= damage;
		
		if self.is_dead():
			self.set_current_animation(Animations.DEAD);
		elif is_hit:
			self.set_current_animation(Animations.HIT);
		
		return damage;
			
	func set_stun_block_frames(value) -> void:
		self.stun_block_frames = value;	
	func set_stun_frames(value) -> void:
		self.stun_frames = value;
	
	func is_block_available() -> bool:
		return self.stun_block_frames < 1;
	func is_stunned() -> bool:
		return self.stun_frames < 1;
	func is_dead() -> bool:
		return self.life < 1;

@export var player_attack: String;
@export var player_block: String;
@export var player_stats: Node;

func attack_received(attack_type) -> void:
	var damage = player.compute_received_attack(attack_type);
	if damage:
		player.set_stun_frames(player_stats.hit_stun_frames[attack_type]);
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
signal on_charge_medium();
signal on_charge_strong();

signal on_stun();

signal on_block_start();
signal on_block_end();

signal on_attack_blocked();
signal on_parade();

signal on_damage_taken();
signal on_dead();

var player;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = Player.new(player_stats, $AnimatedSprite2D, player_attack, player_block, \
		on_attack, on_charge_medium, on_charge_strong, on_parade, on_attack_blocked);
	$AnimatedSprite2D.frame_changed.connect(_animation_progress.bind($AnimatedSprite2D));
	$AnimatedSprite2D.animation_finished.connect(_animation_end.bind($AnimatedSprite2D));
	player.is_combat_ongoing = true;

func _animation_progress(sprite) -> void:
	if sprite.animation == Animations.CHARGE && Input.is_action_pressed(player.attack_action):
		player.is_charging = true;
		
	_handleAttackSignal(sprite, Constants.attack_type.LIGHT);
	_handleAttackSignal(sprite, Constants.attack_type.MEDIUM);
	_handleAttackSignal(sprite, Constants.attack_type.STRONG);

func _handleAttackSignal(sprite, attack_type) -> void:
	if sprite.animation == Animations["ATTACK_" + attack_type] && \
		sprite.frame == player_stats.start_up_frames[attack_type] + player_stats.active_frames[attack_type]:
		player.on_attack.emit(player.current_attack_type);

func _animation_end(sprite) -> void:
	if sprite.animation == Animations.VICTORY:
		sprite.set_frame_and_progress(2, 0.0);
		sprite.play();
	elif sprite.animation == Animations.PARADE:
		player.set_current_animation(Animations.BLOCK);	
		on_block_start.emit();
	elif sprite.animation != Animations.DEAD && sprite.animation != Animations.IDLE:
		player.set_current_animation(Animations.IDLE);

func _input(event) -> void:
	if !player.is_combat_ongoing:
		return;
	
	if event.is_action_released(player.attack_action) && player.current_animation == Animations.CHARGE:
		player.current_attack_type = from_frame_to_attack_type(player.charge_frames);
		$AnimatedSprite2D.play(Animations["ATTACK_" + player.current_attack_type]);
		player.is_charging = false;
		player.reset_charge_frames();
		
	if event.is_action_released(player.block_action):
		player.set_current_animation(Animations.IDLE);
		player.set_stun_block_frames(player_stats.stun_block_frames)
		on_block_end.emit();
	
	if !player.is_action_allowed():
		return;
	
	if event.is_action_pressed(player.attack_action):
		player.set_current_animation(Animations.CHARGE);
	if event.is_action_pressed(player.block_action) && player.is_block_available():
		player.set_current_animation(Animations.PARADE);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player.compute_stun();
	player.compute_stun_block();
	player.compute_charge();
