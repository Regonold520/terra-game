extends Node

@onready var itemManager : ItemManager = get_tree().current_scene.find_child("ItemManager")
@onready var dialogueManager : DialogueManager = get_tree().current_scene.find_child("DialogueManager")

@onready var cam = get_viewport().get_camera_3d()
@onready var ui = get_tree().current_scene.find_child("Wobbler")

func parse_json_path(path):
	var file := FileAccess.open(path, FileAccess.READ)
	if file:
		var json_text := file.get_as_text()
		file.close()
		var result = JSON.parse_string(json_text)
		if result != null:
			var my_dict : Dictionary = result
			return my_dict
		else:
			push_error("Failed to parse JSON")
