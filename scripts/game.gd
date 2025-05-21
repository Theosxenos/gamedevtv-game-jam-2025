class_name Game extends Node2D


@onready var world: World = $World

func _on_build_menu_build(building: String) -> void:
	world.build_building(building)
