extends Button

@export_file var scene_path

func _on_pressed():
	if (scene_path == ""): pass
	get_tree().change_scene_to_file(scene_path)
