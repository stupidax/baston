extends Node

@onready var p1_node = get_parent().get_node("Player");
@onready var p2_node = get_parent().get_node("Player2");
@onready var ui_node = get_parent().get_node("Control/UI");

const FULL_LIFE = 30;
const LIFE_RATIO = FULL_LIFE / 10;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	p1_node.connect("on_attack_hit", self.handleAttack.bind(p2_node));
	p2_node.connect("on_attack_hit", self.handleAttack.bind(p1_node));
	
	p1_node.connect("on_charge_medium", self.handleChargeMedium.bind(p1_node));
	p2_node.connect("on_charge_medium", self.handleChargeMedium.bind(p2_node));
	
	p1_node.connect("on_charge_strong", self.handleChargeStrong.bind(p1_node));
	p2_node.connect("on_charge_strong", self.handleChargeStrong.bind(p2_node));
	
	p1_node.connect("on_parade", self.handleParade.bind(p1_node, p2_node));
	p2_node.connect("on_parade", self.handleParade.bind(p2_node, p1_node));
	
	p1_node.connect("on_block_start", self.handleBlockStart.bind(p1_node));
	p2_node.connect("on_block_start", self.handleBlockStart.bind(p2_node));
	
	p1_node.connect("on_block_end", self.handleBlockEnd.bind(p1_node));
	p2_node.connect("on_block_end", self.handleBlockEnd.bind(p2_node));
	
	p1_node.connect("on_attack_blocked", self.handleAttackBlocked.bind(p2_node));
	p2_node.connect("on_attack_blocked", self.handleAttackBlocked.bind(p1_node));
	
	p1_node.connect("on_damage_taken", self.handleDamageTaken.bind(p1_node));
	p2_node.connect("on_damage_taken", self.handleDamageTaken.bind(p2_node));
	
	ui_node.player_change_life("gain", FULL_LIFE, 1);
	ui_node.player_change_life("gain", FULL_LIFE, 2);
	
	p1_node.connect("on_dead", self.endCombat.bind(p2_node));
	p2_node.connect("on_dead", self.endCombat.bind(p1_node));

func handleAttack(attack_type, player_node) -> void:
	player_node.attack_received(attack_type);

func handleParade(player_node) -> void:
	player_node.parade_received();
	
func handleBlockStart(player_node) -> void:
	# TODO: update UI
	pass
	
func handleBlockEnd(player_node) -> void:
	# TODO: update UI
	pass
	
func handleChargeMedium(player_node) -> void:
	print("test medium")
	# TODO: update charge animation
	pass
	
func handleChargeStrong(player_node) -> void:
	print("test strong")
	# TODO: update charge animation
	pass
	
func handleAttackBlocked(player_node) -> void:
	# TODO: update UI
	pass

func handleDamageTaken(damage, player_node) -> void:
	ui_node.player_change_life("lose", damage * LIFE_RATIO, player_node.player_id);
	
func endCombat(winner_player):
	winner_player.win_combat();
	

func fight() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
