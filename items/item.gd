extends RigidBody3D
class_name Item

@export var id = ""
@onready var erioVal = randi_range(1,100)
@onready var sprite : Sprite3D = find_child("Sprite")

func _ready() -> void:
	if id != "":
		loadData(id)

func loadData(newId):
	sprite = find_child("Sprite")
	sprite.texture = load("res://items/"+newId+"/"+newId+"Item.png")
	id = newId

func onGrab():
	get_viewport().get_camera_3d().currentItem = id
	Ref.cam.find_child("Arm").texture = load("res://items/"+id+"/"+id+"Hold.png")
	
	Ref.cam.currentItemInst = self
	
	find_child("CollisionShape3D").set_deferred("disabled", true)
	reparent(get_tree().root)
	freeze = true
	hide()
