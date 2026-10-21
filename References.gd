extends Node

@onready var itemManager : ItemManager = get_tree().current_scene.find_child("ItemManager")

@onready var cam = get_viewport().get_camera_3d()
