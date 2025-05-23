class_name SpawnLocation extends Node2D

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
	
	add_child(ship)

	print("spawning from %s with coordinates %s" % [name, ship.position])
	current_state = States.SPAWNED
