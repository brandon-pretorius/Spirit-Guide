extends Node3D
const DAMAGE = 5
const SPEED = 10


func _process(delta):
	global_transform.origin -= transform.basis.z.normalized() * SPEED * delta

func _on_area_3d_body_entered(body):
	if body.is_in_group("Enemy"):
		body.health -= DAMAGE
	if !body.is_in_group("Player"):
		queue_free()
