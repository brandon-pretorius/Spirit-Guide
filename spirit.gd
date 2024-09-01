extends Area3D


func _on_body_entered(body):
	if body.is_in_group("Player"):
		$CollectionSound.pitch_scale = randf_range(0.8,1.2)
		$CollectionSound.play(0.1)
		await $CollectionSound.finished
		Global.spirit += 1
		queue_free()
