class_name SpawnController extends Node

@export var spawn_locations: Array[SpawnLocation]

@onready var spawn_timer: Timer = $SpawnTimer

func _ready() -> void:
	for c in get_children():
		if c is SpawnLocation:
			spawn_locations.append(c)


func _on_spawn_timer_timeout() -> void:
	var tries := 0
	var max_tries := 10
	
	while tries < max_tries:
		tries += 1
		
		var i := randi_range(0, spawn_locations.size() - 1)
		if not spawn_locations[i].can_spawn():
			continue
		
		spawn_locations[i].spawn()
		break
	
	tries = 0
	spawn_timer.start()
