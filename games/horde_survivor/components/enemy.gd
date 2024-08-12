extends CharacterBody2D

@onready var animation_tree = $AnimationTree
var state_machine: AnimationNodeStateMachinePlayback

func _ready():
	state_machine = animation_tree.get("parameters/Animation/playback");

func _physics_process(_delta):
	# move_and_slide()
	pass

func drop_loot():
	pass

func take_damage():
	state_machine.travel("despawn");

func _on_hitbox_area_entered(_area):
	take_damage()
