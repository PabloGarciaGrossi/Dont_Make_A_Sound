class_name LevelManager extends Node2D

@export var player : Player
@export var connections : Array[MapConnection]

var data : LevelDataHandoff

# Called when the node enters the scene tree for the first time.
func _ready():
	player.disable()
	
	if data != null:
		enter_level()
		
	pass # Replace with function body.

func enter_level():
	if player != null:
		player.enable()
	_connect_to_doors()

func init_player_location():
	if data != null:
		for door in connections:
			if door.name == data.entrance_name:
				player.position = door.get_player_entry_vector()
		player.orient(data.move_dir)

func _on_player_entered_door(door : MapConnection):
	_disconect_drom_doors()
	player.disable()
	player.queue_free()
	data = LevelDataHandoff.new()
	data.entrance_name = door.entrance_name
	data.move_dir = door.get_move_dir()
	set_process(false)
	

func _connect_to_doors():
	for door in connections:
		if not door.player_entered_map_connection.is_connected(_on_player_entered_door):
			door.player_entered_map_connection.connect(_on_player_entered_door)
		

func _disconect_drom_doors():
	for door in connections:
		if door.player_entered_map_connection.is_connected(_on_player_entered_door):
			door.player_entered_map_connection.disconnect(_on_player_entered_door)
		
