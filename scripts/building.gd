class_name Building extends StaticBody2D

signal destroyed(building: Building)

enum Types {RESOURCE, OTHER}
enum States {ATTACK, IDLE}

@export var building_type: Types
@export var health := 5
@export var attack_damage := 1


var targets: Array[Goblin]
var targeted_enemy: Goblin

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _physics_process(delta: float) -> void:
	pass


func get_relative_direction(target: Node2D) -> Vector2:
	var direction := target.global_position - global_position
	return direction.normalized()


func _on_detection_range_body_entered(body: Node2D) -> void:
	if not body is Goblin:
		return
	
	var direction := get_relative_direction(body)
	
	# Use dot product to determine closest cardinal direction
	if abs(direction.dot(Vector2.UP)) > abs(direction.dot(Vector2.RIGHT)) and direction.dot(Vector2.UP) > 0:
		animation_player.play("attack_up")
	elif abs(direction.dot(Vector2.UP)) > abs(direction.dot(Vector2.RIGHT)) and direction.dot(Vector2.UP) < 0:
		animation_player.play("attack_down")
	elif direction.dot(Vector2.RIGHT) > 0:
		animation_player.play("attack_right")
	else:
		animation_player.play("attack_left")
	
	targets.append(body)
	attack()


func _on_detection_range_body_exited(body: Node2D) -> void:
	if not body is Goblin:
		return
		
	if targets.size() > 0:
		var index := targets.find(body)
		if index >= 0:
			targets.remove_at(index)


func take_hit(damage: int) -> void:
	health -= damage
	if health <= 0:
		destroyed.emit(self)
		queue_free()


func attack() -> void:
	if targets.size() > 0 and not targeted_enemy:
		targeted_enemy = targets.pop_front()
		# Add actual attack logic here
		# For example:
		if targeted_enemy and is_instance_valid(targeted_enemy):
			targeted_enemy.take_hit(attack_damage)
