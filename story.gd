extends Control
var tween
@onready var story := $StoryLines

func _ready():
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(story, "visible_ratio", 1, 20)

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		tween.kill()
		story.visible_ratio = 1


func _on_leave_pressed():
	get_tree().change_scene_to_file("res://World.tscn")
