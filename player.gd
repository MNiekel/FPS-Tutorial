extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var speed = 5
@export var jump_speed = 5
@export var mouse_sensitivity = 0.002

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	var input = Input.get_vector("left", "right", "forward", "backward")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	
	velocity.x = movement_dir.x * speed
	velocity.y += -gravity * delta
	velocity.z = movement_dir.z * speed
	
	move_and_slide()
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed
		
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if event.is_action_pressed("fire"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			print("fire")
			fire()
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(20), deg_to_rad(30))
		
func fire():
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create($gun.global_position, $gun.global_position + $gun.global_transform.basis.z * 10000, 6)
	var collision = space.intersect_ray(query)
	if collision:
		print(collision.collider.name)
	else:
		print("miss")
	
