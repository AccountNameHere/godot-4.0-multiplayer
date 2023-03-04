extends Node3D

func start_server():
	var peer = ENetMultiplayerPeer.new()
	# Creates a server on port 4000, with a max of 5 players
	peer.create_server(4000, 5)
	multiplayer.multiplayer_peer = peer
	$Menu.visible = false
	multiplayer.multiplayer_peer.peer_connected.connect(on_join)

func on_join(id):
	add_player(id)

func start_client():
	var peer = ENetMultiplayerPeer.new()
	# Connects to a localhost server on port 4000
	peer.create_client("127.0.0.1", 4000)
	multiplayer.multiplayer_peer = peer
	$Menu.visible = false
	$Camera3D.current = false

func add_player(id):
	var character = preload("res://player.tscn").instantiate()
	# Names the root of the player to the id to easily transfer the owner id for later
	character.name = str(id);
	character.set_multiplayer_authority(id)
	$Players.add_child(character)