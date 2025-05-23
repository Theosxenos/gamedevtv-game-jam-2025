class_name Ship extends CharacterBody2D

signal returning()

@export var speed := 35.0
@export var direction := Vector2.ZERO
@export var goblin_scene : PackedScene = preload("uid://brlvn56mjcub")
@export var can_unload := true

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.get_animation("rotate").track_set_key_value(0, 0, rotation)
	animation_player.get_animation("rotate").track_set_key_value(0, 1, rotation + PI)


func _physics_process(_delta: float) -> void:
	move()
	
	
func move() -> void:
	velocity = speed * direction
	var collission: bool = move_and_slide()
	if not collission or not can_unload:
		return
	
	unload()


func move_away() -> void:
	animation_player.play("rotate")
	direction *= -1
	
	await animation_player.animation_finished
	
	returning.emit()	
	
		
func unload() -> void:
	var goblin: Goblin = goblin_scene.instantiate()
	goblin.global_position = global_position + Vector2(0, 32)
	get_parent().add_child(goblin)
	can_unload = false

	move_away()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
