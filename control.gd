extends Control


func _on_leave_button_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")
