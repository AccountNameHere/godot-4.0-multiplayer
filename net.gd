extends Node3D

var users = []
var local_player

func start_server():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(4000, 5)
	multiplayer.multiplayer_peer = peer
	$Menu.visible = false
	multiplayer.multiplayer_peer.peer_connected.connect(on_join)

func on_join(id):
	add_player(id)

func start_client():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client("127.0.0.1", 4000)
	multiplayer.multiplayer_peer = peer
	$Menu.visible = false
	$Camera3D.current = false

func add_player(id):
	users.append(id)
	var character = preload("res://player.tscn").instantiate()
	character.name = str(id);
	character.set_multiplayer_authority(id)
	$Players.add_child(character)
	if multiplayer.get_unique_id() == id:
		local_player = character
