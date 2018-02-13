extends "PlayerEntityInstantiator.gd"

# Callbacks
func _on_player_added(id):
    if id == 1: # Player Server has no Player Entity; it has NPC entities
        return
        
    # Send other entities to new entity
    for entity in _entities.get_children():
        rpc_id(id, "slave_add_entity", int(entity.name), entity.transform.origin)
    
    var x = rand_range(-10, 10)
    var y = rand_range(5, 10)
    var z = rand_range(-10, 10)
    var origin = Vector3(x, y, z)    
    # Broadcast new entity
    rpc("sync_add_entity", id, origin)

func _on_player_removed(id):
    if id == 1: # Player Server has no Player Entity; it has NPC entities
        return

    rpc("sync_remove_entity", id)