extends Node3D

func _ready():
	pass
	
func _process(delta):
	pass
		
func spawn_enemy():
	var enemy_scene = load("res://enemy.tscn")
	var enemy_scene_copy = enemy_scene.instantiate()
	enemy_scene_copy.position.x = randi() %20
	enemy_scene_copy.position.z = randi() %20
	add_child(enemy_scene_copy)
