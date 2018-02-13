extends Spatial

# Should belong to Server (Keep in a separate node as master?)
export var _speed = 3

sync var _sync_speed = 3

# Belongs to Owner; Server and Proxies are Slaves; 
# but Server may correct these parameters if Owner is trying to cheat or huge desync happens
slave var _slave_motion = Vector3()

slave var _slave_origin = Vector3()

slave var _slave_linear_velocity = Vector3()

# Variables
const GRAVITY = Vector3(0,-9.8,0)

var linear_velocity = Vector3()

func _physics_process(delta):
    linear_velocity = GRAVITY

    # Owner
    if is_network_master():
        var motion = _process_walk_inputs()
        if _speed != _sync_speed:
            _speed = _sync_speed
        linear_velocity += motion * _speed
        rset("_slave_motion", motion)
        rset("_slave_origin", get_node("KinematicBody").transform.origin)
    # Server
    elif get_tree().is_network_server():        
        #TODO: correct slave_origin / slave_motion if needed
        _speed += delta
        rset("_sync_speed", _speed)
        linear_velocity = _slave_motion * _speed
    # Proxies
    else:
        _speed = _sync_speed
        linear_velocity = _slave_linear_velocity

    # Move them all; useful for validating collision
    linear_velocity = get_node("KinematicBody").move_and_slide(linear_velocity, -GRAVITY.normalized())
    
    # Adjust position for slaves (Server and Proxies)
    if not is_network_master():
        #TODO: interpolate
        get_node("KinematicBody").transform.origin = _slave_origin

    # Sync Proxies
    if get_tree().is_network_server():
        rset("_slave_origin", get_node("KinematicBody").transform.origin)
        rset("_slave_linear_velocity", linear_velocity)        
    
func _process_walk_inputs():
    var motion = Vector3()
    if Input.is_action_pressed("ui_up"):
        motion += Vector3(0, 0, -1)
    if Input.is_action_pressed("ui_down"):
        motion += Vector3(0, 0, 1)
    if Input.is_action_pressed("ui_left"):
        motion += Vector3(-1, 0, 0)
    if Input.is_action_pressed("ui_right"):
        motion += Vector3(1, 0, 0)
    return motion.normalized()