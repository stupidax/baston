class_name PlayerClass

static var Animations = {
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

var is_combat_ongoing;
var life: int;
var direction: bool;
var charge;
var max_charge;
var damage;
var sprite: Sprite2D;
var animation_player;
var attack_action;
var parade_action;
var hit_stun_frames: int;
var block_stun_frames: int;
var pause_frames: int;
var frames_data;
var is_charging;
var keep_charge;
var current_attack_type;

var on_attack_hit;
var on_parade;
var on_block;

func _init(stats_param, sprite_param, animation_player_param, direction_param, attack_action_param, parade_action_param, \
	attack_signal, charge_medium_signal, charge_strong_signal, parade_signal, block_signal):
	
	self.life = stats_param.life;
	self.charge = {
		stats_param.charge_frames[Constants.attack_type.MEDIUM]: charge_medium_signal,
		stats_param.charge_frames[Constants.attack_type.STRONG]: charge_strong_signal
	};
	self.max_charge = stats_param.charge_frames[Constants.key_word.CAP];
	self.frames_data = stats_param;

	self.damage = stats_param.attack_damage;
	
	self.sprite = sprite_param;
	self.sprite.flip_h = direction_param
	self.animation_player = animation_player_param;
	self.attack_action = attack_action_param;
	self.parade_action = parade_action_param;
	self.set_current_animation(Animations.IDLE);
	self.is_charging = false;
	self.is_combat_ongoing = false;
	
	self.on_attack_hit = attack_signal;
	self.on_parade = parade_signal;
	self.on_block = block_signal;
	
func from_frame_to_attack_type():
	if self.sprite.frame >= self.frames_data.charge_frames[Constants.attack_type.STRONG]:
		return Constants.attack_type.STRONG;
	elif self.sprite.frame >= self.frames_data.charge_frames[Constants.attack_type.MEDIUM]:
		return Constants.attack_type.MEDIUM;
	return Constants.attack_type.LIGHT;
	
func compute_keep_charge():
	if self.is_charging:
		self.keep_charge += 1;
	else:
		self.keep_charge = 0;
func is_keeping_charge():
	return self.keep_charge < 3;

func compute_received_attack(attack_received) -> int:
	var is_hit = false;
	var damage = 0;
	if attack_received != Constants.attack_type.STRONG \
		&& self.animation_player.current_animation == Animations.PARADE \
		&& self.sprite.frame >= self.frames_data.start_up_frames[Constants.key_word.PARADE] \
		&& self.sprite.frame <= self.frames_data.active_frames[Constants.key_word.PARADE]:
		
		self.set_current_animation(Animations.COUNTER);
		self.on_parade.emit(self.frames_data.counter_frames);
	elif attack_received != Constants.attack_type.STRONG \
		&& self.animation_player.current_animation == Animations.IDLE:
			
		self.set_current_animation(Animations.BLOCK);
		self.set_block_stun_frames(self.frames_data.block_stun_frames[attack_received]);
		self.on_block.emit(attack_received);
	else:
		damage = self.damage[attack_received];
		is_hit = true;
	
	self.life -= damage;
	
	if self.is_dead():
		self.set_current_animation(Animations.DEAD);
	elif is_hit:
		self.compute_hit(attack_received);
	
	return damage;
func compute_hit(attack_received):
	var is_interrupted = self.can_interrupt(attack_received);
	if attack_received == Constants.attack_type.LIGHT:
		self.compute_keep_charge();
		is_interrupted = !self.is_keeping_charge();
	else:
		self.set_hit_stun_frames(self.frames_data.hit_stun_frames[attack_received])
		
	if is_interrupted:
		self.set_current_animation(Animations.HIT);
func compute_block_stun():
	if self.animation_player.current_animation == Animations.BLOCK:
		self.block_stun_frames -= 1;
func compute_hit_stun():
	if self.is_stunned:
		self.hit_stun_frames -= 1;
func compute_pause():
	if self.pause_frames >= 1:
		self.pause_frames -= 1;
	elif !self.animation_player.is_playing():
		self.set_current_animation(Animations.IDLE);


func pause_animation(nb_frames):
	self.animation_player.pause();
	self.pause_frames = nb_frames;
func set_current_animation(new_animation, next_animation = Animations.IDLE):
	self.animation_player.play(new_animation);
	self.animation_player.queue(next_animation);
	if next_animation != Animations.IDLE:
		self.animation_player.queue(Animations.IDLE)
func set_block_stun_frames(value) -> void:
	self.block_stun_frames = value;
func set_hit_stun_frames(value) -> void:
	self.hit_stun_frames = value;

func can_interrupt(attack_type) -> bool:
	return self.animation_player.current_animation == Animations.CHARGE \
		|| self.animation_player.current_animation == "PARADE" && self.sprite.frame <= self.frames_data.start_up_frames[Constants.key_word.PARADE] \
		|| self.animation_player.current_animation == "ATTACK_" + attack_type && self.sprite.frame <= self.frames_data.start_up_frames[attack_type];
func is_action_allowed() -> bool:
	return !self.is_stunned() \
		|| self.animation_player.current_animation == Animations.IDLE \
		|| self.animation_player.current_animation == Animations.CHARGE;
func is_parade_available() -> bool:
	return self.is_action_allowed() || self.is_charging;
func is_stunned() -> bool:
	return self.hit_stun_frames < 1;
func is_dead() -> bool:
	return self.life < 1;
