class_name Grid extends Node2D

@export var cell_size := Vector2(64,64)
@export var grid_color := Color(0.2, 0.2, 0.2)


@onready var start := $Start.position as Vector2
@onready var end := $End.position as Vector2 


func _draw() -> void:
	_draw_grid()


func _draw_grid() -> void:
	for x in range(start.x, end.x + cell_size.x, cell_size.x):
		draw_line(Vector2(x, start.y), Vector2(x, end.y), grid_color, 1)
	for y in range(start.y, end.y + cell_size.y, cell_size.y):
		draw_line(Vector2(start.x, y), Vector2(end.x, y), grid_color, 1)
