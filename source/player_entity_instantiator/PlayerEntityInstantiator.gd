extends Node

# Dependencies
export (NodePath) var _entities_path
var _entities

# Functions
func _enter_tree():
    _entities = get_node(_entities_path)

func _get_entity(id):
    pass
    
func _create_entity(id, origin):	
    var entity = _get_entity(id)
    entity.name = str(id)
    entity.get_node("KinematicBody").transform.origin = origin
    return entity

func _add_entity(id, origin):
    var entity = _create_entity(id, origin)
    _entities.add_child(entity)
    return entity

func _set_network_master(id, entity):
    pass
    
func _add_entity_as_network_master(id, origin):
    _set_network_master(id, _add_entity(id, origin))

func _remove_entity(id):		
    var entity = _entities.get_node(str(id))
    _entities.remove_child(entity)
    entity.queue_free()

# RPCs
sync func sync_add_entity(id, origin):
    call_deferred("_add_entity_as_network_master", id, origin)
    
sync func sync_remove_entity(id):
    call_deferred("_remove_entity", id)