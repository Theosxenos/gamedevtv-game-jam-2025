class_name Hurtbox extends Area2D

signal hit(damage: int)

func take_hit(damage: int) -> void:
	hit.emit(damage)
