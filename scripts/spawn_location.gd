class_name SpawnLocation extends Node2D

signal ship_unloading(spawn_direction: Vector2, spawn_position: Vector2)

enum States {SPAWNING, SPAWNED, RETURNING, IDLE}

@export var ship_scene: PackedScene = preload("uid://dhvh5ybbmrunr")
@export var ship_direction: Vector2 = Vector2.ZERO
@export_custom(PROPERTY_HINT_NONE, "degrees") var ship_rotation: float = 0

var spawned_ship: Ship

var current_state: States = States.IDLE

func _process(_delta: float) -> void:
	if not spawned_ship:
		return

	if current_state == States.IDLE:
		spawned_ship = null


func can_spawn() -> bool:
	return current_state == States.IDLE
	

func spawn() -> void:
	if current_state == States.SPAWNING or current_state == States.SPAWNED:
		return
	
	current_state = States.SPAWNING
	
	var ship: Ship = ship_scene.instantiate()
	ship.direction = ship_direction
	ship.rotation_degrees = ship_rotation
	ship.returning.connect(func (): current_state = States.IDLE)
	ship.unloading.connect(func (dir: Vector2, pos: Vector2): ship_unloading.emit(dir, pos))
	
	add_child(ship)
	
	current_state = States.SPAWNED
