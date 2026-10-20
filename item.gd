extends Area3D

@export var id = ""

@onready var sprite : Sprite3D = find_child("Sprite")

func _ready() -> void:
	loadData(id)

func loadData(id):
	sprite.texture = load("res://items/"+id+"/"+id+"Item.png")

func onGrab():
	get_viewport().get_camera_3d().currentItem = id
	$"../Wobbler/Arm".texture = load("res://items/"+id+"/"+id+"Hold.png")
	
	queue_free()
