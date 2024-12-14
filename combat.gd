extends Node

@onready var p1_node = get_parent().get_node("Player");
@onready var p2_node = get_parent().get_node("Player2");

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	p1_node.connect("on_attack", self.handleAttack.bind(self, p2_node));
	p2_node.connect("on_attack", self.handleAttack.bind(self, p1_node));

func handleAttack(attack_type, _param, player_node) -> void:
	player_node.attack_received(attack_type);

func fight() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
