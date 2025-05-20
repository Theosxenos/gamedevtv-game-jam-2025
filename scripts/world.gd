class_name World
extends Node2D

@export var min_resources := 2
@export var max_resources := 4
@export var resource_scene: PackedScene
@export var used_grid_cells: Array[Vector2]

@onready var grid_ref: Grid = $Grid


func _ready() -> void:
	if resource_scene == null:
		push_error("Resource scene not assigned")
		return

	# Castle coords
	used_grid_cells.append(Vector2(3, 3))
	used_grid_cells.append(Vector2(4, 3))
	used_grid_cells.append(Vector2(3, 4))
	used_grid_cells.append(Vector2(4, 4))
	
	spawn_resources()


func _generate_coordinates() -> Vector2:
	while true:
		var cell_vector := Vector2(randi_range(0, 7), randi_range(0, 7))
	
		if cell_vector in used_grid_cells:
			push_warning(str(cell_vector) + ": Already in use")
			continue
		
		return cell_vector

	push_error("Problem during coordinate generation")
	return Vector2.ZERO
	
func spawn_resources() -> void:
	var num_resources := randi_range(min_resources, max_resources)

	#	for i in range(num_resources):
	while num_resources:
		var gold_resource: StaticBody2D = resource_scene.instantiate()

		var cell_vector := _generate_coordinates()

		var grid_center := Vector2(grid_ref.cell_size.x / 2, grid_ref.cell_size.y / 2)

		gold_resource.position = Vector2(
			cell_vector.x * grid_ref.cell_size.x + grid_center.x, cell_vector.y * grid_ref.cell_size.y + grid_center.y )
		grid_ref.add_child(gold_resource)

		used_grid_cells.append(cell_vector)
		num_resources -= 1
