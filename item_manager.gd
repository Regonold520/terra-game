extends Node3D
class_name ItemManager

func _ready() -> void:
	spawnItem("scissors", Vector3(1.10, 1, -9.0))

func spawnItem(id, pos):
	var baseScr = load("res://items/item.gd")
	var baseScn = load("res://items/item.tscn").instantiate()
	
	var loadScr = load("res://items/"+id+"/"+id+".gd")
	if  loadScr != null:
		baseScr = loadScr
	baseScn.set_script(baseScr)
	add_child(baseScn)
	
	baseScn.global_position = pos
	baseScn.loadData(id)
	
	return baseScn

func spawnInstancedItem(instance : Item, pos):
	instance.reparent(self)
	instance.global_position = pos
	
	instance.find_child("CollisionShape3D").set_deferred("disabled", false)
	instance.freeze = false
	instance.show()
	
	return instance
