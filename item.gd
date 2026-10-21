extends RigidBody3D

@export var id = ""

@onready var sprite : Sprite3D = find_child("Sprite")

func _ready() -> void:
	if id != "":
		loadData(id)

func loadData(newId):
	sprite.texture = load("res://items/"+newId+"/"+newId+"Item.png")
	id = newId

func onGrab():
	get_viewport().get_camera_3d().currentItem = id
	$"../Player/CamPivot/Camera3D/Arm".texture = load("res://items/"+id+"/"+id+"Hold.png")
	
	queue_free()
