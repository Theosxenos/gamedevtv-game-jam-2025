class_name World
extends Node2D

signal building_placed(building: Building)
signal resource_changed(total_resoource_amount: int)

@export var min_resources := 2
@export var max_resources := 4
@export var resource_scene: PackedScene
@export var used_grid_cells: Array[Vector2]
@export var is_building: bool
@export var selected_building: BuildingBlueprint
@export var selected_building_name: String

var buildings: Dictionary = {
								"mine": preload("res://scenes/buildings/gold_mine/gold_mine.tscn"),
								"warrior": preload("res://scenes/buildings/warrior/warrior.tscn")
							}
var building_blueprints: Dictionary = {
								"mine": preload("res://scenes/buildings/blue_prints/gold_mine/gold_mine_bp.tscn"),
								"warrior": preload("res://scenes/buildings/blue_prints/warrior/warrior_bp.tscn")
							}

@onready var grid_ref: Grid = $Grid
@onready var building_controller: BuildingController = $BuildingController

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

	
func _input(event: InputEvent) -> void:
	if not is_building:
		return
	
	if event is InputEventMouseMotion:
		selected_building.set_bp_position(event.position - grid_ref.global_position)
	elif event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				place_building()
			MOUSE_BUTTON_RIGHT:
				_cancel_build_mode()


func _cancel_build_mode() -> void:
	is_building = false
	selected_building.hide()
	selected_building.queue_free()
			
		
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
		
		
func build_building(building_name: String):
	if is_building:
		selected_building.hide()
		selected_building.queue_free()
	else:
		is_building = true
	
	selected_building = building_blueprints[building_name].instantiate()
	selected_building_name = building_name
	
	grid_ref.add_child(selected_building)
	selected_building.set_bp_position(grid_ref.global_position - get_viewport().get_mouse_position()) # TODO probably reverse

	
func place_building() -> void:
	if not selected_building.can_place:
		return
	
	var building: Building = buildings[selected_building_name].instantiate()
	building.position = selected_building.position
	
	grid_ref.add_child(building)
	_cancel_build_mode()
	building_placed.emit(building)


func _on_building_controller_resource_changed(resource_amount: int) -> void:
	resource_changed.emit(resource_amount)
