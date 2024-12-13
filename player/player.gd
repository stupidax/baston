extends Node2D

const Animations = {
	"ATTACK": "attack", 
	"BLOCK": "block", 
	"COUNTER": "counter", 
	"DEAD": "dead", 
	"HIT": "hit", 
	"IDLE": "idle", 
	"PARADE": "parade"
}
class Player:
	const DEFAULT_LIFE = 10;
	const STRONG_CHARGE_NEEDED = 14;
	const IMPARABLE_CHARGE_NEEDED = 28;
	const MAX_CHARGE = 30;
	
	var life;
	var current_animation;
	var charge_frames;
	var is_charging;
	
	func _init(life_param):
		self.life = life_param;
		self.current_animation = Animations.IDLE;
		self.charge_frames = 0;
		self.is_charging = false;
	
	func set_current_animation(new_animation):
		self.current_animation = new_animation;
	func is_action_allowed() -> bool:
		return self.current_animation == Animations.IDLE || self.current_animation == Animations.BLOCK;
	
	func increment_charge_frames():
		self.charge_frames += 1;
	func reset_charge_frames():
		self.charge_frames = 0;
	func is_max_charge():
		return self.charge_frames == MAX_CHARGE;
	
	func is_dead() -> bool:
		return self.life < 1;

@export var playerLife: int = Player.DEFAULT_LIFE;

var player;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = Player.new(playerLife);
	$AnimatedSprite2D.frame_changed.connect(_animation_progress.bind($AnimatedSprite2D));
	$AnimatedSprite2D.animation_finished.connect(_animation_end);
	$AnimatedSprite2D.play(Animations.IDLE);

func _animation_progress(sprite) -> void:
	if sprite.animation == Animations.ATTACK && sprite.is_playing() && sprite.frame == 4 && Input.is_action_pressed(Animations.ATTACK):
		sprite.pause();
		player.is_charging = true;

func _animation_end() -> void:
	player.set_current_animation(Animations.IDLE);
	$AnimatedSprite2D.play(Animations.IDLE);

func handleAnimation(event, animation) -> void:
	if event.is_action_pressed(animation):
		player.set_current_animation(animation);
		$AnimatedSprite2D.play(animation);

func _input(event) -> void:
	if event.is_action_released(Animations.ATTACK):
		$AnimatedSprite2D.play();
		player.is_charging = false;
		
	if event.is_action_released(Animations.BLOCK):
		player.set_current_animation(Animations.IDLE);
		$AnimatedSprite2D.play(Animations.IDLE);
	
	if !player.is_action_allowed():
		return;
	
	handleAnimation(event, Animations.ATTACK);
	handleAnimation(event, Animations.COUNTER);
	handleAnimation(event, Animations.BLOCK);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
