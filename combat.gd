extends Node

@onready var p1_node = get_parent().get_node("Player");
@onready var p2_node = get_parent().get_node("Player2");
@onready var ui_node = get_parent().get_node("Control/UI");

func get_linked_player(link_type, player_node) -> Node2D:
	if link_type == "same":
		if player_node.player_id == p1_node.player_id: return p1_node;
		else: return p2_node;
	elif link_type == "opposite":
		if player_node.player_id == p1_node.player_id: return p2_node;
		else: return p1_node;
	else:
		return player_node;

const FULL_LIFE = 30;
const LIFE_RATIO = FULL_LIFE / 10;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var combat_signals = get_node("combat_signals").get_script().signals;
	for s in combat_signals:
		for p_node in [p1_node, p2_node]:
			var p_bound = get_linked_player(combat_signals[s].link_type, p_node);
			p_node.connect(s, self[combat_signals[s].function_name].bind(p_bound));
	
	ui_node.player_change_life("gain", FULL_LIFE, 1);
	ui_node.player_change_life("gain", FULL_LIFE, 2);
	

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
