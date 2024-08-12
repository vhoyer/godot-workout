extends CharacterBody2D

@onready var animation_tree = $AnimationTree
var state_machine: AnimationNodeStateMachinePlayback

@export var HP = 2

func _ready():
	state_machine = animation_tree.get("parameters/Animation/playback");

func _physics_process(_delta):
	move_and_slide()
	velocity = lerp(velocity, Vector2.ZERO, 0.1);
	pass

func _process(_delta):
	var not_walking_velocity = 10;
	if velocity.x > not_walking_velocity:
		animation_tree.set("parameters/Flip/blend_position", velocity.x)
	if velocity.length() > not_walking_velocity:
		animation_tree.set("parameters/Animation/attack/blend_position", velocity.y)
	animation_tree.set("parameters/Animation/conditions/walking", velocity.length() > not_walking_velocity)
	animation_tree.set("parameters/Animation/conditions/not_walking", velocity.length() < not_walking_velocity)

func drop_loot(): # called by animation
	pass

func take_damage(attack: AttackHitbox):
	HP -= 1;
	if (HP <= 0):
		state_machine.travel("despawn");
	else:
		state_machine.travel("damage");
		velocity += attack.knockback_velocity(self);

func _on_hitbox_area_entered(attack: AttackHitbox):
	take_damage(attack)
