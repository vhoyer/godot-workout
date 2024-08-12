extends CharacterBody2D

func _physics_process(delta):
	# move_and_slide()
	pass

func drop_loot():
	pass

func take_damage():
	queue_free()

func _on_hitbox_area_entered(area):
	take_damage()
