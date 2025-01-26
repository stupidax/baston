extends Node2D

var player;
@onready var Animations = get_node("Class").get_script().Animations;

signal on_attack_hit();
signal on_charge_medium();
signal on_charge_strong();
signal on_stun();
signal on_block_start();
signal on_block_end();
signal on_attack_blocked();
signal on_parade();
signal on_damage_taken();
signal on_dead();

@export var player_id: int;
@export var player_attack: String;
@export var player_parade: String;
@export var player_stats: Node;
@export var is_server: bool;

func from_frame_to_attack_type(frame_number):
	if frame_number >= player_stats.charge_frames[Constants.attack_type.STRONG]:
		return Constants.attack_type.STRONG;
	elif frame_number >= player_stats.charge_frames[Constants.attack_type.MEDIUM]:
		return Constants.attack_type.MEDIUM;
	return Constants.attack_type.LIGHT;

func attack_received(attack_type) -> void:
	var damage = player.compute_received_attack(attack_type);
	if damage:
		player.set_hit_stun_frames(player_stats.hit_stun_frames[attack_type]);
		on_damage_taken.emit(damage);
		
	if player.is_dead():
		player.is_combat_ongoing = false;
		on_dead.emit();
	
func parade_received() -> void:
	player.set_current_animation(Animations.COUNTER);
	
func win_combat() -> void:
	player.is_combat_ongoing = false;
	player.set_current_animation(Animations.VICTORY);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("Class").Player.new(player_stats, $AnimatedSprite2D, player_attack, player_parade, \
		on_attack_hit, on_charge_medium, on_charge_strong, on_parade, on_attack_blocked);
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
		player.on_attack_hit.emit(player.current_attack_type);

func _animation_end(sprite) -> void:
	if sprite.animation == Animations.VICTORY:
		sprite.set_frame_and_progress(2, 0.0);
		sprite.play();
	elif sprite.animation == Animations.HIT && player.is_keeping_charge():
		if Input.is_action_pressed(player.attack_action):
			player.set_current_animation(Animations.CHARGE);
		else:
			handle_attack_input_release();
		
	elif sprite.animation != Animations.DEAD && sprite.animation != Animations.IDLE:
		player.set_current_animation(Animations.IDLE);
		on_block_start.emit();

func _input(event) -> void:
	if !player.is_combat_ongoing:
		return;
	
	if event.is_action_released(player.attack_action) && player.current_animation == Animations.CHARGE:
		handle_attack_input_release();
	
	if !player.is_action_allowed():
		return;
	
	if event.is_action_pressed(player.parade_action) && player.is_parade_available():
		player.reset_charge()
		player.set_current_animation(Animations.PARADE);
	elif event.is_action_pressed(player.attack_action):
		player.set_current_animation(Animations.CHARGE);

func handle_attack_input_release() -> void:
	player.current_attack_type = from_frame_to_attack_type(player.charge_frames);
	player.set_current_animation(Animations["ATTACK_" + player.current_attack_type]);
	player.reset_charge();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player.compute_hit_stun();
	player.compute_block_stun();
	player.compute_charge();
	intro_position(delta);

func intro_position(p_delta):
	if self.position.y > 21:
		self.position.y -= p_delta * 25
		if self.position.y < 21:
			self.position.y = 21
