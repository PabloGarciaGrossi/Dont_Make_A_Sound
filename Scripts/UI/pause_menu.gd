extends MarginContainer

@onready var UI_Controller = $"../"

var config = ConfigFile.new()

func _on_resume_pressed():
	UI_Controller.pauseMenu()
	pass # Replace with function body.


func _on_quit_pressed():
	Scene_Manager.load_new_scene("res://Scenes/Menus/root_scene.tscn", "fade_to_black")
	Engine.time_scale = 1


func _on_save_pressed():
	var player = get
	config.set_value("position", "x", round(player.position.x))
	config.set_value("position", "y", round(player.position.y))
	config.save("res://savegame.cfg")
	pass # Replace with function body.

