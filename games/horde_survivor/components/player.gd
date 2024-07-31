extends CharacterBody2D

var speed = 400  # speed in pixels/sec
var direction
var combo = 0

@onready var animation_tree = $AnimationTree
@onready var combo_timer = $ComboTimer

func _physics_process(delta):
	process_combo(delta)
	
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()

func process_combo(delta):
	if (Input.is_action_just_pressed("attack")):
		combo += 1
	if combo > 0 and combo_timer.is_stopped():
		combo_timer.start(1)
	if combo > 2:
		combo = 0

func reset_combo():
	combo = 0

func _process(delta):
	if direction.x != 0:
		animation_tree.set("parameters/Flip/blend_position", direction.x)
	animation_tree.set("parameters/Animation/attack_1/blend_position", direction.y)
	animation_tree.set("parameters/Animation/attack_2/blend_position", direction.y)
	animation_tree.set("parameters/Animation/conditions/walking", velocity.length() > 0)
	animation_tree.set("parameters/Animation/conditions/not_walking", velocity.length() == 0)
	animation_tree.set("parameters/Animation/conditions/combo_1", combo >= 1)
	animation_tree.set("parameters/Animation/conditions/combo_2", combo >= 2)

func _on_combo_timer_timeout():
	reset_combo()
