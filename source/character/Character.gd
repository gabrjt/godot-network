extends Spatial

# Dependencies
export (NodePath) var _kinematic_body_path
var _kinematic_body

# Variables
export var _speed = 3 # TODO: Speed Node; Inject dependency; Speed Node authority belongs to Server!

var _motion = Vector3()

slave var _slave_motion = Vector3()

slave var _slave_origin = Vector3()

var _linear_velocity = Vector3()

const GRAVITY = Vector3(0,-9.8,0) # TODO: Move to const utils file

# Functions
func _enter_tree():
    _kinematic_body = get_node(_kinematic_body_path)

func _physics_process(delta):    
    _linear_velocity = GRAVITY + _motion * _speed
    _linear_velocity = _kinematic_body.move_and_slide(_linear_velocity, -GRAVITY.normalized())

func _can_sync():
    return is_inside_tree() and get_tree().get_meta("network_peer").get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED