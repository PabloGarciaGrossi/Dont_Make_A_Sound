extends Area2D

class_name InteractableObject

signal player_entered(object : InteractableObject)
signal player_exited(object : InteractableObject)
var player_in_range : bool
func _on_body_entered(body):
	if not body is Player:
		return
	body.UI_Interact.play("icon_appear")
	player_in_range = true

func _on_body_exited(body):
	if not body is Player:
		return
	body.UI_Interact.play("icon_disappear")
	player_in_range = false
	player_exited.emit(self)
	
func _process(delta):
	if player_in_range and Input.is_action_just_pressed("Interact"):
			interaction()
			
func interaction():
	player_entered.emit(self)
