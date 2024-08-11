extends CharacterBody2D

var speed = 400  # speed in pixels/sec
var direction
var attack = 0

@onready var animation_tree = $AnimationTree
var state_machine: AnimationNodeStateMachinePlayback

@onready var animation_player = $AnimationPlayer
@onready var combo_timer = $ComboTimer

func _ready():
	y_sort_enabled = true
	animation_tree.active = true
	state_machine = animation_tree.get("parameters/Animation/playback");

func _physics_process(delta):
	process_combo()
	process_movement()
	move_and_slide()

func process_movement():
	if (is_attacking()):
		velocity = Vector2.ZERO
		return
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed

func process_combo():
	if (!Input.is_action_just_pressed("attack")): return
	var current = state_machine.get_current_node()
	if (attack == 0):
		combo_timer.start(0.7)
		state_machine.travel("attack_1")
	elif (attack == 1 && current == "attack_1"):
		combo_timer.start(0.7)
		state_machine.travel("attack_2")
	attack += 1

func is_attacking():
	var current = state_machine.get_current_node()
	return current.begins_with("attack")

func _on_combo_timer_timeout():
	attack = 0

func _process(delta):
	if direction.x != 0:
		animation_tree.set("parameters/Flip/blend_position", direction.x)
	if velocity.length() > 0:
		animation_tree.set("parameters/Animation/attack_1/blend_position", direction.y)
		animation_tree.set("parameters/Animation/attack_2/blend_position", direction.y)
	animation_tree.set("parameters/Animation/conditions/walking", velocity.length() > 0)
	animation_tree.set("parameters/Animation/conditions/not_walking", velocity.length() == 0)
