extends CharacterBody3D

var mouseSens = 0.005 

var twistInput = 0
var pitchInput = 0

@onready var cam = get_viewport().get_camera_3d()

var speed = 500
var jumpVec = 7
var wallJumpVec = 8

var wallSlideAccel = 2
var maxWallSpeed = 8

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
	
	twistInput = 0
	pitchInput = 0

func _physics_process(delta: float) -> void:
	camMovement()
	
	if not is_on_floor():
		
		
		if is_on_wall():
			if startSlide == false and wallJump == false:
				startSlide = true
			if wallJump:
				velocity.y = clamp(velocity.y - wallSlideAccel * delta, -maxWallSpeed, 0)
		else:
			velocity += get_gravity() * delta
		
	if is_on_floor():
		startSlide = false
		if wallJump == false:
			wallJump = true
		if Input.is_action_just_pressed("Jump"):
			velocity.y = jumpVec
		
	var inputDir := Input.get_vector("Left", "Right", "Up", "Down")
	var dir = (transform.basis * Vector3(inputDir.x, 0, inputDir.y)).normalized()
	
	velocity.x = move_toward(velocity.x, dir.x * 10, 50 * delta)
	velocity.z = move_toward(velocity.z, dir.z * 10, 50 * delta)
	
	if is_on_wall():
		if Input.is_action_just_pressed("Jump") and wallJump:
			startSlide = false
			velocity.y = wallJumpVec
			
			velocity.x = get_wall_normal().x * 15
			velocity.z = get_wall_normal().z * 15
			
	move_and_slide()
