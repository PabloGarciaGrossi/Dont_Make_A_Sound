extends TextureProgressBar

var current_value : float
@export var velocity_value_change = 200.0

# Called when the node enters the scene tree for the first time.
func _ready():
	current_value = value
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		value = lerp(value, current_value, delta * velocity_value_change)


func _on_enemy_character_damage(dmg, position):
	current_value -= dmg
	pass # Replace with function body.


func _on_enemy_2_character_damage(dmg, position):
	pass # Replace with function body.
