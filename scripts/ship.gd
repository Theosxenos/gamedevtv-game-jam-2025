class_name Ship extends CharacterBody2D

@export var speed := 35.0
@export var direction := Vector2.ZERO
@export var goblin_scene : PackedScene = preload("uid://brlvn56mjcub")
@export var can_unload := true

func _physics_process(_delta: float) -> void:
	velocity = speed * direction
	var collission: bool = move_and_slide()
	if not collission or not can_unload:
		return
	
	var goblin: Goblin = goblin_scene.instantiate()
	goblin.global_position = global_position + Vector2(0, 32)
	get_parent().add_child(goblin)
	can_unload = false