class_name BuildingController extends Node

signal resource_changed(resource_amount: int)

@export var building_cost := 5
@export var resource_amount := 10: 
	set(value):
		resource_amount = value
		resource_changed.emit(resource_amount)
@export var resource_per_tick := 1

var buildings: Array[Building]


func _ready() -> void:
	await get_tree().root.ready
	resource_changed.emit(resource_amount)


func build(building: Building) -> void:
	if not can_build():
		print("Not enough resources")
		return
	
	resource_amount -= building_cost
	
	if building.building_type == building.Types.RESOURCE:
		buildings.append(building)


func destroy(building: StaticBody2D) -> void:
	buildings = buildings.filter(func (b: StaticBody2D): return b.get_instance_id() != building.get_instance_id() )


func can_build() -> bool:
	return resource_amount >= building_cost


func _on_resource_timer_timeout() -> void:
	resource_amount += buildings.size() * resource_per_tick
