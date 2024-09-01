extends CharacterBody3D


@onready var raycast = $RayCast3D
@onready var animation = $AnimatedSprite3D
@onready var ani = $AnimationPlayer
@onready var eyes = $Eyes 
@onready var bullet_timer = $BulletTimer
@onready var health_bar = $SubViewport/ProgressBar

var health = 200
var max_health = 200
var spirit = load("res://spirit.tscn")


const TURN_SPEED = 2
const SPEED = 2

enum{
	IDLE,
	ATTACK
}

var target
var state = IDLE
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
		
		ATTACK:
			animation.play("ATTACK")
			ani.play("turn")
			


func _on_bullet_timer_timeout():
	instance = bullet.instantiate()
	instance.position = eyes.global_position
	instance.position.y += 0.3
	instance.transform.basis = eyes.global_transform.basis
	get_parent().add_child(instance)
	
	


func _on_attack_radius_body_entered(body):
	if body.is_in_group("Player"):
		state = ATTACK
		bullet_timer.start()


func _on_attack_radius_body_exited(body):
	if body.is_in_group("Player"):
		state = IDLE
		bullet_timer.stop()
