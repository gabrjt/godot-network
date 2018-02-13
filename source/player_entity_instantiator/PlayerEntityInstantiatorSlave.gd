extends "PlayerEntityInstantiator.gd"

# Dependencies

# Proxy Entity
export (PackedScene) var _slave_entity

# Owner Entity; client has authority over this entity
export (PackedScene) var _master_entity

# Functions
func _get_entity(id):
	return _master_entity.instance() if id == get_tree().get_network_unique_id() else _slave_entity.instance()

func _set_network_master(id, entity):
	if id == get_tree().get_network_unique_id():
		entity.set_network_master(id)
		print("Authority of Entity %s granted" % entity.name)

# RPCs
slave func slave_add_entity(id, origin):
	_add_entity(id, origin)