extends CharacterBody2D

var speed = 400  # speed in pixels/sec

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()

var is_finished = true
var animation_queue: Array[String] = []

func _ready():
	$AnimatedSprite2D.animation_finished.connect(finish)

func finish(): is_finished = true

func _process(delta):
	var animation = "idle"
	if velocity.length() > 0:
		animation = "walk"
		$AnimatedSprite2D.flip_h = velocity.x < 0
	
	if Input.is_action_pressed("attack"):
		animation = "attack-side-one"
	
	if (is_finished):
		is_finished = false
		$AnimatedSprite2D.play(animation)

