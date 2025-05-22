class_name ResourceBuildingBlueprint extends BuildingBlueprint


func _physics_process(_delta: float) -> void:
	if not has_overlapping_areas() or not has_overlapping_bodies():
		can_place = false
		modulate = Color.RED
		return
		
	var overlapping_bodies := get_overlapping_bodies()
	if overlapping_bodies[0].collision_layer > 1:
		can_place = false
		modulate = Color.RED
		return

	can_place = true
	modulate = Color.GREEN
