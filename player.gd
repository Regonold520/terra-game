extends CharacterBody3D

var mouseSens = 0.005 

var twistInput = 0
var pitchInput = 0

@onready var cam = get_viewport().get_camera_3d()

var speed = 17
var jumpVec = 10
var wallJumpVec = 14

var wallSlideAccel = 10
var maxWallSpeed = 3

@onready var uiRot = create_tween()

var wallJumps = 3:
	set(value):
		wallJumps = value
		var newRot = randf_range(-10, 10)
		uiRot.kill()
		uiRot = create_tween()
		
		$CamPivot/Camera3D/Sprite3D.rotation_degrees.z = newRot
		uiRot.tween_property($CamPivot/Camera3D/Sprite3D, "rotation_degrees:z", 0, 1).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
		
		for i in $CamPivot/Camera3D/Sprite3D.get_children():
			i.texture = load("res://barEmpty.png")
		
		for i in value:
			$CamPivot/Camera3D/Sprite3D.find_child(str(i+1)).texture = load("res://barFilled.png")



var maxWallJumps = 3

var wallCamAngle = 0.0
var targetWallCamAngle = 0.0
var maxLean = 10

var wallJump = true
var startSlide = false


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func  _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif event is InputEventMouseButton:
		if event.pressed:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twistInput = -event.relative.x * mouseSens
			pitchInput = -event.relative.y * mouseSens

func camMovement():
	self.rotate_y(twistInput)
	cam.rotate_x(pitchInput)
	
	cam.rotation_degrees.z = wallCamAngle
	
	twistInput = 0
	pitchInput = 0

func _physics_process(delta: float) -> void:
	camMovement()
	
	if not is_on_floor():
		
		
		if is_on_wall():
			if get_wall_normal().dot(global_transform.basis.x) > 0:
				targetWallCamAngle = -maxLean
			else:
				targetWallCamAngle = maxLean
			
			
			if startSlide == false and wallJumps <= 0:
				startSlide = true
			velocity.y = clamp(velocity.y - wallSlideAccel * delta, -maxWallSpeed, 0)
		else:
			velocity += get_gravity() * delta
		
	if is_on_floor():
		startSlide = false
		if wallJumps < maxWallJumps:
			wallJumps = maxWallJumps
		if Input.is_action_just_pressed("Jump"):
			velocity.y = jumpVec
		
	var inputDir := Input.get_vector("Left", "Right", "Up", "Down")
	var dir = (transform.basis * Vector3(inputDir.x, 0, inputDir.y)).normalized()
	
	velocity.x = move_toward(velocity.x, dir.x * speed, 100 * delta)
	velocity.z = move_toward(velocity.z, dir.z * speed, 100 * delta)
	
	wallCamAngle = lerp(wallCamAngle, float(targetWallCamAngle), delta*5)
	
	if is_on_wall():
		
		if Input.is_action_just_pressed("Jump") and wallJumps > 0:
			wallJumps -= 1
			startSlide = false
			velocity.y = wallJumpVec
			
			velocity.x = get_wall_normal().x * 15
			velocity.z = get_wall_normal().z * 15
	else:
		targetWallCamAngle = 0
			
	move_and_slide()
