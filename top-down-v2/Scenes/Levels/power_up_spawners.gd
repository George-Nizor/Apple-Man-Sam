extends Node

@onready var spawners : Array
@onready var powerup = preload("res://Scenes/PowerUp.tscn")
@onready var can_spawn: bool = true
@onready var power_up_timer: Timer = $Power_Up_timer
var previous_spawner: Marker2D = null
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	spawners = get_all_children(self)
	pass

func get_all_children(node: Node):
	var _spawners: Array
	for child in node.get_children():
		if child is Marker2D:
			_spawners.append(child)
	return _spawners

func spawn_powerup(spawner_list):
	var selected_spawner: Marker2D
	var powerup = powerup.instantiate()
	
	var random_index = rng.randi_range(0, 2)  # This gives us 0, 1, or 2
	# Convert the random index directly to the enum value
	match random_index:
		0: powerup.type = PowerUp.PowerUpType.SPEED
		1: powerup.type = PowerUp.PowerUpType.DAMAGE
		2: powerup.type = PowerUp.PowerUpType.HEALTH
	var valid_spawners = spawner_list.duplicate()
	if previous_spawner != null:
		valid_spawners.erase(previous_spawner)
 
	# Select from valid spawners
	selected_spawner = valid_spawners[rng.randi() % valid_spawners.size()]
	previous_spawner = selected_spawner
	powerup.global_position = selected_spawner.global_position
	powerup.player = get_tree().get_root().get_node("Test_Level/Player")
	get_parent().add_child(powerup)
	can_spawn = false
	

func _physics_process(delta: float) -> void:
	if can_spawn:
		spawn_powerup(spawners)
		print("spawned")
		power_up_timer.start()
	

func _on_power_up_timer_timeout() -> void:
	can_spawn = true
