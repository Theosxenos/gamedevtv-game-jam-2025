class_name SpawnController extends Node

@export var locations_per_side := 8
@export var spawn_location_scene: PackedScene = preload("uid://dmhsn1ju4haeh")
@export var spawn_locations: Array[SpawnLocation]

@export var goblin_scene: PackedScene = preload("uid://brlvn56mjcub")

@onready var spawn_timer: Timer = $SpawnTimer

# Direction configurations for each side
const SPAWN_SIDES: Dictionary = {
	"north": {"rotation": 0, "direction": Vector2.DOWN, "node": "NorthSpawnStart", "offset_direction": Vector2.RIGHT},
	"south": {"rotation": 180, "direction": Vector2.UP, "node": "SouthSpawnStart", "offset_direction": Vector2.RIGHT},
	"west": {"rotation": -90, "direction": Vector2.RIGHT, "node": "WestSpawnStart", "offset_direction": Vector2.DOWN},
	"east": {"rotation": 90, "direction": Vector2.LEFT, "node": "EastSpawnStart", "offset_direction": Vector2.DOWN}
}

func _ready() -> void:
	_initialize_spawn_locations()
	spawn_timer.start()

func _initialize_spawn_locations() -> void:
	for side_name in SPAWN_SIDES:
		var side_config = SPAWN_SIDES[side_name]
		var start_node: Node2D = get_node(side_config["node"])
		
		var locations: Array[SpawnLocation] = _create_locations(
			side_config["rotation"], 
			side_config["direction"],
			side_config["offset_direction"]
		)
		
		for location in locations:
			start_node.add_child(location)
			spawn_locations.append(location)

func _create_locations(ship_degrees: int, ship_direction: Vector2, offset_direction: Vector2) -> Array[SpawnLocation]:
	var locations: Array[SpawnLocation] = []
	const SPACING: int = 64
	
	for i in range(locations_per_side):
		var location: SpawnLocation = spawn_location_scene.instantiate()
		location.position += offset_direction * i * SPACING
		location.ship_direction = ship_direction
		location.ship_rotation = ship_degrees
		location.ship_unloading.connect(_ship_unloading)
		
		locations.append(location)
	
	return locations

func _on_spawn_timer_timeout() -> void:
	if _attempt_spawn():
		spawn_timer.start()

func _attempt_spawn() -> bool:
	const MAX_TRIES := 10
	
	for _try in range(MAX_TRIES):
		var index := randi_range(0, spawn_locations.size() - 1)
		if spawn_locations[index].can_spawn():
			spawn_locations[index].spawn()
			return true
	
	return false

func _ship_unloading(spawn_direction: Vector2, spawn_position: Vector2) -> void:
	var goblin: Goblin = goblin_scene.instantiate()
	goblin.direction = spawn_direction
	goblin.global_position = spawn_position
	
	add_child(goblin)	
