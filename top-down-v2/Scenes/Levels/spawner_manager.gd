extends Node

@onready var spawners : Array
@onready var enemy = preload("res://Scenes/Entities/enemies/enemy.tscn")
@onready var enemy2 = preload("res://Scenes/Entities/enemy_2.tscn")
@onready var enemy3 = preload("res://Scenes/Entities/enemies/enemy_3.tscn")
@onready var can_spawn: bool = true
@onready var spawn_timer: Timer = $SpawnTimer
var broc_counter: int = 0

func _ready() -> void:
	spawners = get_all_children(self)
	pass
	
func select_enemy():
	if broc_counter == 3:
		broc_counter += 1
		return enemy2
	if broc_counter > 5:
		broc_counter = 0
		return enemy3
	else:
		broc_counter += 1
		return enemy
		

func get_all_children(node: Node):
	var _spawners: Array
	for child in node.get_children():
		if child is Marker2D:
			_spawners.append(child)
	return _spawners

func spawn_enemy(spawner_list):
	var selected_spawner: Marker2D
	var enemy = select_enemy().instantiate()
	selected_spawner = spawner_list[randi() % spawner_list.size()]
	enemy.global_position = selected_spawner.global_position
	get_parent().add_child(enemy)
	can_spawn = false
	

func _physics_process(delta: float) -> void:
	if can_spawn:
		spawn_enemy(spawners)
		spawn_timer.start()
	

func _on_spawn_timer_timeout() -> void:
	can_spawn = true
