extends Node2D

var player: PlayerClass;
@onready var Animations = PlayerClass.Animations;

signal on_attack_hit(attack_type);
signal on_charge_medium();
signal on_charge_strong();
signal on_stun();
signal on_attack_blocked(attack_type);
signal on_parade(nb_frames);
signal on_damage_taken();
signal on_dead();

@export var player_id: int;
@export var player_direction: bool;
@export var player_attack: String;
@export var player_parade: String;
@export var player_stats: Node;
@export var player_sprite: Sprite2D;
@export var is_server: bool;

func attack_received(attack_type) -> void:
	var damage = player.compute_received_attack(attack_type);
	if damage:
		player.set_hit_stun_frames(player_stats.hit_stun_frames[attack_type]);
		on_damage_taken.emit(damage);
		
	if player.is_dead():
		player.is_combat_ongoing = false;
		on_dead.emit();
	
func parade_received(nb_frames) -> void:
	player.pause_animation(nb_frames);
	
func win_combat() -> void:
	player.is_combat_ongoing = false;
	player.set_current_animation(Animations.VICTORY);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !player_sprite:
		player_sprite = $Sprite
	player = PlayerClass.new(player_stats, player_sprite, $AnimationPlayer, player_direction, player_attack, player_parade, \
		on_attack_hit, on_charge_medium, on_charge_strong, on_parade, on_attack_blocked);
	player_sprite.frame_changed.connect(_animation_progress.bind(player_sprite, $AnimationPlayer));
	player.is_combat_ongoing = true;

func _animation_progress(sprite, animation_player) -> void:
	if animation_player.current_animation == Animations.CHARGE && Input.is_action_pressed(player.attack_action):
		player.is_charging = true;
		
	_handleAttackSignal(sprite, animation_player, Constants.attack_type.LIGHT);
	_handleAttackSignal(sprite, animation_player, Constants.attack_type.MEDIUM);
	_handleAttackSignal(sprite, animation_player, Constants.attack_type.STRONG);

func _handleAttackSignal(sprite, animation_player, attack_type) -> void:
	if animation_player.current_animation == Animations["ATTACK_" + attack_type] && \
		sprite.frame == player_stats.active_frames[attack_type]:
		player.on_attack_hit.emit(attack_type);

func _animation_end(sprite, animation_player) -> void:
	if animation_player.current_animation == Animations.VICTORY:
		sprite.set_frame_and_progress(2, 0.0);
		sprite.play();
		
	elif animation_player.current_animation != Animations.DEAD && animation_player.current_animation != Animations.IDLE:
		player.set_current_animation(Animations.IDLE);

func _input(event) -> void:
	if !player.is_combat_ongoing:
		return;
	
	if event.is_action_released(player.attack_action) && player.animation_player.current_animation == Animations.CHARGE:
		handle_attack_input_release();
	
	if !player.is_action_allowed():
		return;
	
	if event.is_action_pressed(player.parade_action) && player.is_parade_available():
		player.is_charging = false;
		player.set_current_animation(Animations.PARADE);
	elif event.is_action_pressed(player.attack_action):
		player.set_current_animation(Animations.CHARGE, Animations.ATTACK_STRONG);

func handle_attack_input_release() -> void:
	player.current_attack_type = player.from_frame_to_attack_type();
	player.is_charging = false;
	player.set_current_animation(Animations["ATTACK_" + player.current_attack_type]);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player.compute_hit_stun();
	player.compute_block_stun();
	player.compute_pause();
	intro_position(delta);

func intro_position(p_delta):
	if self.position.y > 21:
		self.position.y -= p_delta * 25
		if self.position.y < 21:
			self.position.y = 21
