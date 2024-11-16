class_name Player extends CharacterBody2D

@onready var movement: MovementComponent = $MovementComponent
@onready var gun: Node2D = $AnimatedSprite2D/gun_pistol
@onready var animated_sprite = $AnimatedSprite2D
@export var health: Healthcomponent
@export var power_up: PowerUp = null
@export var normal_damage = 50
@export var boosted_damage = 100
var current_damage = normal_damage

# Call this function when a power-up is picked up
func pick_up_power_up(new_power_up: PowerUp):
	power_up = new_power_up  # Assign the new power-up
	# Connect the signals for the new power-up
	power_up.speedboost.connect(speed_boost)
	power_up.damageboost.connect(damage_boost)
	power_up.healthboost.connect(health_up)

func _ready() -> void:
	health.kill_player.connect(kill_player)
	health.update_health.connect(send_health)
	#power_up.speedboost.connect(speed_boost)
	#power_up.damageboost.connect(damage_boost)
	#power_up.healthboost.connect(health_up)


func Player():
	pass

func handle_rotation():
	var mouse = get_global_mouse_position()
	animated_sprite.flip_h = mouse.x < position.x

func handle_animations():
	if velocity.is_zero_approx():
		animated_sprite.play("idle")
	else:
	# Determine if the player is walking opposite to the direction they're facing
		var moving_opposite = (velocity.x < 0 and !animated_sprite.flip_h) or (velocity.x > 0 and animated_sprite.flip_h)

		# Play the run animation forwards or backwards based on movement direction
		if moving_opposite:
			animated_sprite.play_backwards("Run")
		else:
			animated_sprite.play("Run")
	
func _physics_process(delta: float) -> void:
	var direction = movement.get_movement_direction()
	handle_rotation()
	movement.move_object(direction)
	handle_animations()

func kill_player(amount: int):
	get_parent().get_node("UI/Game_Over").visible = true
	animated_sprite.rotation += amount
	animated_sprite.scale.x = amount
	process_mode = PROCESS_MODE_DISABLED
	$Death_Sound.play()
	await get_tree().create_timer(3).timeout
	if GlobalStuff.high_score < GlobalStuff.SCORE:
		GlobalStuff.high_score = GlobalStuff.SCORE
		GlobalStuff.save_data.high_score = GlobalStuff.high_score
		GlobalStuff.save_data.save()
	GlobalStuff.PLAYER_HEALTH = health.max_health
	GlobalStuff.SCORE = 0
	get_tree().change_scene_to_file("res://Scenes/Menus/main_menu.tscn")
	print("Great job you fucking piece of ufkc tyhiasdnfioajbngiksj")
	
func send_health():
	GlobalStuff.PLAYER_HEALTH = health.health
	
func speed_boost():
	print("Speed Boosted")
	$AnimatedSprite2D.speed_scale *= 2
	$Speed_Boost.play()
	movement.moveSpeed += 100
	await get_tree().create_timer(10).timeout
	$AnimatedSprite2D.speed_scale /= 2
	movement.moveSpeed -= 100

func damage_boost():
	print("Damage Boosted")
	$AnimatedSprite2D/gun_pistol.mode = 1
	$AnimatedSprite2D/gun_pistol/AnimatedSprite2D.play("fire_2")
	current_damage = boosted_damage
	scale.x = 1.2
	scale.y = 1.2
	await get_tree().create_timer(10).timeout
	current_damage = normal_damage
	$AnimatedSprite2D/gun_pistol.mode = 0
	scale.x = 1
	scale.y = 1

func health_up():
	print("health added")
	health.increase(50)
	send_health()
