class_name BuildMenu extends Control

signal build(building: String)

var can_build := false: set = toggle_build_mode
var resource_amount := 0: set = set_resource_amount

func _on_mine_button_pressed() -> void:
	build.emit("mine")


func _on_knight_button_pressed() -> void:
	build.emit("warrior")


func toggle_build_mode(value: bool) -> void:
	can_build = value
	
	var modulate_color: Color = Color.WHITE if can_build else Color.RED

	for c in %ButtonContainer.get_children():
		c.modulate = modulate_color
		c.disabled = not can_build


func set_resource_amount(total_amount: int) -> void:
	resource_amount = total_amount
	%GoldLabel.text = "Gold: %s" % resource_amount
