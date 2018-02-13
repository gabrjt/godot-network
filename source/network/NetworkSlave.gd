extends "Network.gd"

# Variables
export var _server_ip = "127.0.0.1"

# Functions
func _connect_callbacks():
    ._connect_callbacks()
    get_tree().connect("connected_to_server", self, "_connected_to_server")
    get_tree().connect("server_disconnected", self, "_server_disconnected")
    get_tree().connect("connection_failed", self, "_connected_failed")

func _connect():
    if not _server_ip.is_valid_ip_address():
        print("IP address %s is invalid" % _server_ip)
        return
    
    var peer = NetworkedMultiplayerENet.new()
    peer.create_client(_server_ip, _server_port)
    get_tree().set_network_peer(peer)
    get_tree().set_meta("network_peer", peer)

# Callbacks
func _connected_to_server():
    print("Client connected to server @%s:%d" % [_server_ip, _server_port])
    var id = get_tree().get_network_unique_id()
    rpc("master_add_player", id)
        
func _server_disconnected():
    get_tree().quit()
        
func _connected_failed():
    get_tree().quit()

# RPCs
slave func slave_add_player(id):
	_add_player(id)