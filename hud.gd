extends CanvasLayer

@onready var ani =  $AnimatedSprite2D
@onready var ammo_bar = $AmmoBar
@onready var cooldown = $Cooldown
@onready var aniplayer = $AnimationPlayer
@onready var health_bar = $HealthBar
@onready var spirit_number = $SpiritNumber
var tween

func _ready():
	ammo_bar.value = Global.current_ammo
	ammo_bar.max_value = Global.max_ammo
	health_bar.max_value = 100
	
	
func _process(delta):
	spirit_number.text = str(Global.spirit)
	health_bar.value = Global.player_health
	print(Global.player_health)
	if Global.current_ammo <=0:
		Global.can_shoot = false 
	if Input.is_action_just_pressed("shoot") and Global.can_shoot:
		ani.play("shoot")
		Global.current_ammo -= 1
		ammo_bar.value = Global.current_ammo
		cooldown.start()
		print("yeah")
	else:
		ani.play("idle")
	


func _on_cooldown_timeout():
	if Global.current_ammo < Global.max_ammo:
		#Global.can_shoot =  false
		if tween:
			tween.kill()
		tween = get_tree().create_tween()
		tween.tween_property(ammo_bar, "value", 10, 1)
		print (ammo_bar.value)
		await tween.finished
		Global.can_shoot = true
		Global.current_ammo = 10
		
		
		
	
		
