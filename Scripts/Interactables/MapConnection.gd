class_name MapConnection extends InteractableObject

signal player_entered_map_connection(obj : MapConnection)

@export_enum("north", "east", "south", "west") var entry_direction
@export_enum("fade_to_black") var transition_type : String

@export var push_distance = 16
@export var path_to_new_scene : String
@export var entrance_name : String


func _on_body_entered(body:Node) -> void:
	super(body)

func interaction():
	player_entered_map_connection.emit(self)
	Scene_Manager.load_new_scene(path_to_new_scene, transition_type)
	queue_free()

func get_player_entry_vector() -> Vector2:
	var vector : Vector2 = Vector2.LEFT
	match entry_direction:
		0:
			vector = Vector2.UP
		1:
			vector = Vector2.RIGHT
		2: 
			vector = Vector2.DOWN
	return (vector * push_distance) + self.position
	
func get_move_dir() -> Vector2:
	var dir : Vector2 = Vector2.RIGHT
	match entry_direction:
		0:
			dir = Vector2.DOWN
		1:
			dir = Vector2.LEFT
		2: 
			dir = Vector2.UP
	return dir
