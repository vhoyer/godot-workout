extends Area2D
class_name AttackHitbox

@export var damage = 1
@export var knockback_force = 600
@export_node_path("Node2D") var origin;
@onready var origin_node: Node2D = get_node(origin)

func knockback_velocity(target: Node2D) -> Vector2:
	var direction: Vector2 = target.position - origin_node.position
	return direction.normalized() * knockback_force
