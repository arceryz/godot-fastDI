class_name Player extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 3.5

@onready var PlayerCamera: Camera3D = %PlayerCamera

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var cam_sens_h: float = ProjectSettings.get("gameplay/camera_sensitivity_horizontal")
		var cam_sens_v: float = ProjectSettings.get("gameplay/camera_sensitivity_vertical")
		event.relative.x *= -cam_sens_v
		event.relative.y *= -cam_sens_h
		PlayerCamera.rotation_degrees.y += event.relative.x
		PlayerCamera.rotation_degrees.x = clamp(PlayerCamera.rotation_degrees.x+event.relative.y, -89.9, 89.9)
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (PlayerCamera.transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	direction = Vector3(direction.x, 0, direction.z).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
