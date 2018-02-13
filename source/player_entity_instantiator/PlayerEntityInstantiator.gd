extends Node

# Dependencies
export (NodePath) var _entities_path
var _entities

export (PackedScene) var _entity

# Functions
func _enter_tree():
    _entities = get_node(_entities_path)
    
func _create_entity(id, origin):	
    var entity = _entity.instance()
    entity.name = str(id)
    entity.transform.origin = origin
    return entity

func _add_entity(id, origin):
    var entity = _create_entity(id, origin)
    _entities.add_child(entity)

func _remove_entity(id):		
    var entity = _entities.get_node(str(id))
    _entities.remove_child(entity)
    entity.free()
    
# RPCs
sync func sync_add_entity(id, origin):
    _add_entity(id, origin)
    
sync func sync_remove_entity(id):
    _remove_entity(id)