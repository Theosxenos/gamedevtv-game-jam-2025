class_name BuildingBlueprint extends Area2D


@onready var parent: Grid = get_parent()

func _physics_process(_delta: float) -> void:
	if has_overlapping_bodies():
		modulate = Color.RED
	else:
		modulate = Color.GREEN



func set_bp_position(value: Vector2) -> void:
	if not has_overlapping_areas():
		position = value
		return

	var grid_cell := Vector2(
						 floor(value.x / parent.cell_size.x),
						 floor(value.y / parent.cell_size.y)
					 )

	var cell_center := Vector2(parent.cell_size.x / 2, parent.cell_size.y / 2)

	var grid_pos := grid_cell * parent.cell_size + cell_center

	position = grid_pos
