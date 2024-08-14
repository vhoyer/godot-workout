extends CharacterBody2D

@onready var animation_tree = $AnimationTree
var state_machine: AnimationNodeStateMachinePlayback
var try_attacking = false;

@export var HP = 2;
@export var Speed = 250;

@export_node_path("Node2D") var NodeToFollow;
@onready var node_to_follow: Node2D = get_node(NodeToFollow);
var direction: Vector2;

func _ready():
	state_machine = animation_tree.get("parameters/Animation/playback");

func _physics_process(delta):
	velocity = lerp(velocity, Vector2.ZERO, 0.1);
	
	var current = state_machine.get_current_node()
	var voluntary_states: Array[String] = ['idle', 'walk'];
	
	if (voluntary_states.has(current)):
		process_movement(delta);
	
	move_and_slide();

func process_movement(delta):
	if (try_attacking):
		state_machine.travel("attack");
	else:
		direction = node_to_follow.position - self.position;
		velocity += direction.normalized() * Speed * delta

func _process(_delta):
	var current = state_machine.get_current_node()
	var not_walking_velocity = 10;
	if (direction.x != 0):
		animation_tree.set("parameters/Flip/blend_position", direction.x)
	if velocity.length() > not_walking_velocity:
		animation_tree.set("parameters/Animation/attack/blend_position", velocity.y)
	animation_tree.set("parameters/Animation/conditions/walking", velocity.length() > not_walking_velocity)
	animation_tree.set("parameters/Animation/conditions/not_walking", velocity.length() < not_walking_velocity)

func drop_loot(): # called by animation
	pass

func take_damage(attack: AttackHitbox):
	HP -= 1;
	if (HP <= 0):
		state_machine.travel("death");
	else:
		state_machine.travel("damage");
		velocity += attack.knockback_velocity(self);

func _on_hitbox_area_entered(attack: AttackHitbox):
	take_damage(attack)

func _on_melee_range_body_entered(body):
	try_attacking = true;


func _on_melee_range_body_exited(body):
	try_attacking = false;
