extends Node3D

var idealPosition = Vector3.ZERO
var lerpy = 160

func _process(delta: float) -> void:
	var cam = get_viewport().get_camera_3d()
	
	var weight = 1.0 - exp(-lerpy * delta)
	
	idealPosition = idealPosition.lerp(cam.global_position, weight)
	
	global_position = global_position.lerp(idealPosition, weight)
	

	global_rotation = get_viewport().get_camera_3d().global_rotation
