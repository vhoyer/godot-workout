extends CharacterBody2D

var speed = 400  # speed in pixels/sec
var direction

@onready var animation_tree = $AnimationTree

func _physics_process(delta):
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()

func _process(delta):
	print(direction.x)
	animation_tree.set("parameters/Flip/blend_position", direction.x)
	animation_tree.set("parameters/Animation/attack_1/blend_position", direction.y)
	animation_tree.set("parameters/Animation/attack_2/blend_position", direction.y)
	animation_tree.set("parameters/Animation/conditions/walking", velocity.length() > 0)
	animation_tree.set("parameters/Animation/conditions/not_walking", velocity.length() == 0)
