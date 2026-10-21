extends Node3D

var idealPosition = Vector3.ZERO
var lerpy = 160

var deltaTimer = 0.0
func _process(delta: float) -> void:
	deltaTimer += delta
	
	$"../Player/Camera3D/Arm".position.y = 0.0 + sin(deltaTimer)/20
	
	var cam = get_viewport().get_camera_3d()
	
	var weight = 1.0 - exp(-lerpy * delta)
	
	idealPosition = idealPosition.lerp(cam.global_position, weight)
	
	global_position = cam.global_position
	

	global_rotation = get_viewport().get_camera_3d().global_rotation
