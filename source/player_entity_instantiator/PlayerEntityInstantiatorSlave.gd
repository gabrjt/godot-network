extends "PlayerEntityInstantiator.gd"

# Functions
func _set_network_master(id, entity):
	if id == get_tree().get_network_unique_id():
		entity.set_network_master(id)
		print("Authority of Entity %s granted" % entity.name)

# RPCs
slave func slave_add_entity(id, origin):
	_add_entity(id, origin)