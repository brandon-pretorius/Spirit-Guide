extends Node3D

const DAMAGE = 5
const SPEED = 5

@onready var ray = $RayCast3D

func _process(delta):
	global_transform.origin -= transform.basis.z.normalized() * SPEED * delta
	#position += transform.basis * Vector3(0, 0, -SPEED) * delta

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		Global.player_health-= DAMAGE
	if ! body.is_in_group("Enemy"):
		queue_free()
