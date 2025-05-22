class_name Goblin extends CharacterBody2D

@export var speed := 30.0
@export var direction := Vector2.ZERO

func _ready() -> void:
	direction = Vector2.DOWN

func _physics_process(_delta: float) -> void:
	velocity = direction * speed
	var collission = move_and_slide()