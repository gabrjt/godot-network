extends "Network.gd"

# Variables
export var _maximum_players = 16

# Functions
func _connect_callbacks():
    ._connect_callbacks()
    get_tree().connect("network_peer_connected", self, "_network_peer_connected")

func _connect():
    var peer = NetworkedMultiplayerENet.new()
    if peer.create_server(_server_port, _maximum_players) != OK:
        print("Server at %d is already running. Aborting..." % _server_port)
        return
    print("Server initialized at %d ; Maximum Players: %d" % [_server_port, _maximum_players])
    
    get_tree().set_network_peer(peer)
    get_tree().set_meta("network_peer", peer)
    
    var id = get_tree().get_network_unique_id()
    _add_player(id)

# Callbacks
func _network_peer_connected(id):
    print ("Player %d connected to server..." % id)

# RPCs
master func master_add_player(id):    
    # Send other slaves to new slave
    for player_id in _player_ids:
        rpc_id(id, "slave_add_player", player_id)
    # Broadcast new slave to all slaves and master
    rpc("sync_add_player", id)