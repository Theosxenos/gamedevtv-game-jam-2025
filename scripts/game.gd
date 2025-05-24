class_name Game extends Node2D


@onready var build_menu: BuildMenu = $BuildMenu
@onready var world: World = $World
@onready var building_controller: BuildingController = world.get_node("BuildingController")

func _on_build_menu_build(building: String) -> void:
	world.build_building(building)


func _on_world_resource_changed(total_resoource_amount: int) -> void:
	build_menu.resource_amount = total_resoource_amount
	build_menu.can_build = building_controller.can_build()


func _on_world_building_placed(building: Building) -> void:
	building_controller.build(building)
