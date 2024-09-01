extends CharacterBody3D


var bullet = load("res://red_bullet.tscn")
var instance

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var neck := $Neck
@onready var camera := $Neck/Camera3D
@onready var gundir := $Neck/Camera3D/GunDirection
@onready var info = $Info

func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(30))
			
		
func _physics_process(delta):
	info.text = ""
	if gundir.is_colliding():
		var collision = gundir.get_collider()
		if collision is Interactable:
			if Global.spirit < 10:
				info.text = "You need " + str(10 - Global.spirit) + " more souls to leave."
			else:
				info.text = "Press 'E' to leave"
				if Input.is_action_just_pressed("shoot"):
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
					get_tree().change_scene_to_file("res://win.tscn")
	
	if Global.player_health <= 0:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_file("res://gameover.tscn")
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		$JumpSound.pitch_scale = randf_range(0.8,1.2)
		$JumpSound.play()
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		if $Timer.time_left <= 0:
			$AudioStreamPlayer.pitch_scale = randf_range(0.8,1.2)
			$AudioStreamPlayer.play()
			$Timer.start(0.4)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	if Input.is_action_just_pressed("shoot") and Global.can_shoot:
		$PlasmaGunSound.pitch_scale = randf_range(0.8,1.2)
		$PlasmaGunSound.play()
		instance = bullet.instantiate()
		instance.position = global_position
		instance.position.y += 1
		instance.transform.basis = camera.global_transform.basis
		get_parent().add_child(instance)
