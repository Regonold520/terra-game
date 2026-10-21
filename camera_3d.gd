extends Camera3D

@onready var raycast : RayCast3D = find_child("Interactor")
var canCollectItem = null

var currentItem = null
var currentItemInst = null

var canSwing = true
var swingers = 2
var swings = [0.1, 0.3, 0]
var isSwinging = false

var holdTime = 0

var canNpcInteract

func swing():
	if currentItem != null and isSwinging == false and holdTime <= 0:
		isSwinging = true
		for i in swingers + 1:
			if i + 1 > swingers:
				isSwinging = false
				$Arm.texture = load("res://items/"+currentItem+"/"+currentItem+"Hold.png")
			else:	
				$Arm.texture = load("res://items/"+currentItem+"/"+currentItem+"Swing"+str(i+1)+".png")
			
			await get_tree().create_timer(swings[i]).timeout

func _ready() -> void:
	pass # Replace with function body.

var deltaTimer = 0.0
func _process(delta: float) -> void:
	if currentItemInst:
		print(currentItemInst.erioVal)
	if Input.is_action_just_pressed("Click"):
		swing()
	
	
	deltaTimer += delta
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		
		if collider is Item:
			canCollectItem = collider
			$"../../Wobbler/PromptImg".texture = load("res://pickup.png")
		if collider is NPC and canCollectItem == null:
			canNpcInteract = collider
			$"../../Wobbler/PromptImg".texture = load("res://talk.png")
	else:
		canCollectItem = null
		canNpcInteract = null
	print(canNpcInteract, "npc")
	$"../../Wobbler/PromptImg".visible = canCollectItem != null or canNpcInteract != null


	if canNpcInteract != null and Input.is_action_just_pressed("Grab"):
		Ref.dialogueManager.initiateDialogue(canNpcInteract, "test")
	
	$"../../Wobbler/PromptImg".rotation_degrees.z = floor((sin(deltaTimer*5)+0.5))*10
	
	if canCollectItem != null and Input.is_action_just_pressed("Grab") and currentItem == null:
		canCollectItem.onGrab()
		
		
	if Input.is_action_pressed("Drop") and currentItem != null and isSwinging == false:
		holdTime = clamp(holdTime + (delta*15), 0, 20)
	elif holdTime > 0:
		throwItem()
		
		holdTime = 0
		
		
		
func throwItem():
	var newInstance = Ref.itemManager.spawnInstancedItem(currentItemInst, global_position)
	
	currentItemInst = null
	currentItem = null
	
	var vec = (($"..".transform.basis * transform.basis) * Vector3(0, 0, -1)).normalized()
	vec *= holdTime
	
	newInstance.apply_impulse(vec)
	
	$Arm.texture = load("res://camArm1.png")
