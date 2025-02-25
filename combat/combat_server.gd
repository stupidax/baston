extends Node

signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected

const PORT = 7000;
const MAX_CONNECTIONS = 2;

var players = {}
var players_loaded = 0;

func get_ip() -> String:
	# TODO: Retrieve IP from player
	return "127.0.0.1";

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func create_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CONNECTIONS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	player_connected.emit(1, {}) # TODO: add player info
	# TODO: load fight scene
	
func join_game():
	var peer = ENetMultiplayerPeer.new()
	print(multiplayer.get_remote_sender_id());
	print(multiplayer.get_unique_id());
	peer.create_client(get_ip(), PORT)
	multiplayer.multiplayer_peer = peer

# When the server decides to start the game from a UI scene,
# do ?.load_game.rpc()
@rpc("call_local", "reliable")
func load_game():
	get_tree().change_scene_to_file("Game")

# Every peer will call this when they have loaded the game scene.
@rpc("any_peer", "call_local", "reliable")
func player_loaded():
	if multiplayer.is_server():
		players_loaded += 1
		if players_loaded == players.size():
			# TODO: $/root/Game.start_game()
			players_loaded = 0
			
# When a peer connects, send them my player info.
# This allows transfer of all desired data for each player, not only the unique ID.
func _on_player_connected(id):
	_register_player.rpc_id(id, {})
	
@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)

func _on_player_disconnected(id):
	players.erase(id)
	player_disconnected.emit(id)

func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = {}
	player_connected.emit(peer_id, {})

func _on_connected_fail():
	multiplayer.multiplayer_peer = null

func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()

func remove_multiplayer_peer():
	multiplayer.multiplayer_peer = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
