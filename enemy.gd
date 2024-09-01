extends CharacterBody3D

@onready var raycast = $RayCast3D
@onready var animation = $AnimatedSprite3D
@onready var eyes = $Eyes 
@onready var bullet_timer = $BulletTimer
@onready var health_bar = $SubViewport/HealthBar

var health = 50
var max_health = 50


const TURN_SPEED = 2
const SPEED = 2

enum{
	IDLE,
	WALK,
	ATTACK,
}

var target
var state = IDLE
var spirit = load("res://spirit.tscn")
var bullet = load("res://ectoplasm.tscn")
var instance
var instance_spirit

func _physics_process(delta):
	
	health_bar.max_value = max_health
	health_bar.value = health
	
	if health <= 0:
		instance_spirit = spirit.instantiate()
		instance_spirit.position = global_position
		get_parent().add_child(instance_spirit)
		SoundManager.play("res://death_1.mp3")
		queue_free()
	
	match state:
		IDLE:
			animation.play("IDLE")
		WALK:
			eyes.look_at(target.global_transform.origin, Vector3.UP)
			rotate_y(deg_to_rad(eyes.rotation.y * TURN_SPEED))
			var dir = target.global_position - global_position
			dir.y = 0.0
			dir = dir.normalized()
			velocity = dir * SPEED
			move_and_slide()
		
		ATTACK:
			animation.play("ATTACK")
			eyes.look_at(target.global_transform.origin, Vector3.UP)
			rotate_y(deg_to_rad(eyes.rotation.y * TURN_SPEED))
		
			


func _on_sight_range_body_entered(body):
	if body.is_in_group("Player"):
		state = ATTACK
		target = body
		bullet_timer.start()


func _on_sight_range_body_exited(body):
	if body.is_in_group("Player"):
		state = WALK
	


func _on_walk_range_body_entered(body):
	if body.is_in_group("Player"):
		state = WALK
		target = body


func _on_walk_range_body_exited(body):
	if body.is_in_group("Player"):
		state = IDLE
		bullet_timer.stop()

func _on_bullet_timer_timeout():
	print("shoot")
	instance = bullet.instantiate()
	instance.position = global_position
	instance.position.y += 0.7
	instance.transform.basis = global_transform.basis
	get_parent().add_child(instance)

func death_sound():
	$DeathSound.play()
	await $DeathSound.finished
