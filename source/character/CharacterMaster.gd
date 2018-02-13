extends "Character.gd"

# Functions
func _process(delta):
	_motion = _process_walk_inputs()
	
	if _can_sync():
		rset_unreliable("_sync_motion", _motion)
		rset_unreliable("_sync_origin", _kinematic_body.transform.origin)

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