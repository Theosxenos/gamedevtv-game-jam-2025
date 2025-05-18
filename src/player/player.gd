class_name Player extends CharacterBody2D

@export var speed := 30
@export var animation_player: AnimationPlayer
@export var sprite: Sprite2D

var _direction := Vector2.ZERO


func _ready() -> void:
	# TODO delete after proper sprite
	sprite.scale *= 0.5


func _process(_delta: float) -> void:
	_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")


func _physics_process(_delta: float) -> void:
	if _direction == Vector2.ZERO:
		animation_player.play("idle")
		return

	velocity = _direction * speed
	move_and_slide()
