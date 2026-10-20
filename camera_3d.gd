extends Camera3D

@onready var raycast : RayCast3D = find_child("Interactor")
var canCollectItem = null

var currentItem = null

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		
		if collider.is_in_group("Item"):
			canCollectItem = collider
	else:
		canCollectItem = null
	
	if canCollectItem != null and Input.is_action_just_pressed("Grab") and currentItem == null:
		canCollectItem.onGrab()
