extends Node

# Variables
export var _server_port = 8910

export var _auto_connect = true

var _player_ids = []

# Signals
signal player_added(id, player)

signal player_removed(id, player)

# Functions
func _ready():	
	_connect_callbacks()
	if _auto_connect:
		_connect()

func _connect_callbacks():
	get_tree().connect("network_peer_disconnected", self, "_network_peer_disconnected")

func _connect():
	pass

func _add_player(id):
	_player_ids.append(id)
	emit_signal("player_added", id)
	print("Player %d added" % id)

func _remove_player(id):
	_player_ids.erase(id)
	emit_signal("player_removed", id)
	print("Player %d removed" % id)

# Callbacks
func _network_peer_disconnected(id):
	print ("Player %d disconnected..." % id)
	_remove_player(id)
	
# RPCs
sync func sync_add_player(id):
	_add_player(id)