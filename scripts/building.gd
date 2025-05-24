class_name Building extends StaticBody2D

signal destroyed(building: Building)

enum Types {RESOURCE, OTHER}
enum States {ATTACK, IDLE}
	
@export var building_type: Types
@export var health := 5

var targets: Array[Goblin]
var targeted_enemy: Goblin

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	%Hurtbox.hit.connect(_on_hurtbox_hit)


func _physics_process(delta: float) -> void:
	pass


func get_relative_direction(target: Node2D) -> Vector2:
	var direction := target.global_position - global_position
	return direction.normalized()


func _on_detection_range_body_entered(body: Node2D) -> void:
	if not body is Goblin:
		return

	var direction := get_relative_direction(body)
	match direction:
		Vector2.UP:
			animation_player.play("attack_up")
		Vector2.RIGHT:
			animation_player.play("attack_right")
		Vector2.DOWN:
			animation_player.play("attack_down")
		Vector2.LEFT:
			animation_player.play("attack_left")

	

	targets.append(body)
	attack()


func _on_detection_range_body_exited(body: Node2D) -> void:
	if not body is Goblin:
		return
		
	targets.remove_at(
		targets.find(func (e: Goblin): e.get_instance_id() == body.get_instance_id())
	)


func _on_hurtbox_hit(damage: int) -> void:
	health -= damage
	if health <= 0:
		destroyed.emit(self)
		queue_free()

		
func attack() -> void:
	if not targeted_enemy:
		targeted_enemy = targets.pop_front()
		
