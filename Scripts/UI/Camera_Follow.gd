extends Camera2D

var current_following_character : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	current_following_character = get_tree().get_nodes_in_group("Player")[0]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if current_following_character != null:
		global_position = current_following_character.global_position
