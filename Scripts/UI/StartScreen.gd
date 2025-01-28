class_name StartScreen extends Control

func _process(delta):
	if Input.is_action_just_pressed("Interact"):
		Scene_Manager.load_new_scene("res://Scenes/City.tscn")
