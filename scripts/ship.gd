class_name Ship extends CharacterBody2D

signal returning()

enum States {MOVING, UNLOADING}

@export var speed := 35.0
@export var direction := Vector2.ZERO
@export var goblin_scene : PackedScene = preload("uid://brlvn56mjcub")
@export var can_unload := true

var current_state := States.MOVING


func _physics_process(_delta: float) -> void:
	if current_state != States.MOVING:
		return
	
	move()
	
	
func move() -> void:
	velocity = speed * direction
	var collission: bool = move_and_slide()
	if not collission or not can_unload:
		return
	
	unload()


func move_away() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	await get_tree().process_frame
	
	var tween := create_tween()
	tween.finished.connect(_on_tween_finished)
	tween.tween_property(self, "rotation", rotation + PI, 1)

		
func unload() -> void:
	current_state = States.UNLOADING
	
	var goblin: Goblin = goblin_scene.instantiate()
	goblin.global_position = global_position + Vector2(0, 32)
	get_parent().add_child(goblin)
	can_unload = false

	move_away()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_tween_finished() -> void:
	direction *= -1
	current_state = States.MOVING
	
	returning.emit()
