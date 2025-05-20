class_name World extends Node2D


@export var min_resources := 2
@export var max_resources := 4

@export var resource_scene: PackedScene

func _ready() -> void:
	if resource_scene == null:
		push_error("Resource scene not assigned")
		return
		
	var num_resources := randi_range(min_resources, max_resources)
	var grid_ref: Grid = $Grid
	
	for i in range(num_resources):
		var gold_resource: StaticBody2D = resource_scene.instantiate()
		if gold_resource is StaticBody2D:
			# Use grid's cell size instead of hardcoded values
			var cell_x := randi_range(1, 8)
			var cell_y := randi_range(1, 8)
			gold_resource.position = Vector2(grid_ref.cell_size.x / 2 * cell_x, grid_ref.cell_size.y / 2 * cell_y)
			grid_ref.add_child(gold_resource)
		else:
				push_error("Resource scene must inherit from StaticBody2D")
				gold_resource.queue_free()
