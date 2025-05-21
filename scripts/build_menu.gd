class_name BuildMenu extends Control

signal build(building: String)


func _on_mine_button_pressed() -> void:
	build.emit("mine")


func _on_knight_button_pressed() -> void:
	build.emit("warrior")
