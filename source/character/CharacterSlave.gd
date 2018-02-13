extends "Character.gd"

# Functions
func _process(delta):    
    # TODO: in this case, server and proxies are slaves... new scripts for them or if is_network_server()?
    if _can_sync():
        _motion = _slave_motion
        _kinematic_body.transform.origin = _slave_origin