extends Node
class_name SceneManager

signal _content_finished_loading(content)	## internal - triggered when content is loaded and final data handoff and transition out begins
signal _content_invalid(content_path:String)	## internal - triggered when attempting to load invalid content (e.g. an asset does not exist or path is incorrect)
signal _content_failed_to_load(content_path:String)	## internal - triggered when loading has started but failed to complete

var loading_screen : LoadingScreen
var _loading_screen_scene : PackedScene = preload("res://Scenes/Menus/LoadingScreen.tscn")
var _transition : String
var _content_path : String
var _load_progress_timer : Timer

#const GAME SCENES = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	_content_invalid.connect(_on_content_invalid)
	_content_failed_to_load.connect(_on_content_failed_to_load)
	_content_finished_loading.connect(_on_content_finished_loading)

func load_new_scene(content_path : String, transition_type : String = "fade_to_black"):
	_transition = transition_type
	loading_screen = _loading_screen_scene.instantiate() as LoadingScreen
	get_tree().root.add_child(loading_screen)
	loading_screen.start_transition(transition_type)
	_load_content(content_path)
	
func _load_content(content_path : String):
	if loading_screen != null:
		await loading_screen.transition_in_complete
		
	_content_path = content_path
	var loader = ResourceLoader.load_threaded_request(content_path)
	if not ResourceLoader.exists(content_path) or loader == null:
		_content_invalid.emit(content_path)
		return
	_load_progress_timer = Timer.new()
	_load_progress_timer.wait_time = 0.1
	_load_progress_timer.timeout.connect(monitor_load_status)
	get_tree().root.add_child(_load_progress_timer)
	_load_progress_timer.start()

func monitor_load_status():
	var load_progress = []
	var load_status = ResourceLoader.load_threaded_get_status(_content_path, load_progress)
	
	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			_content_invalid.emit(_content_path)
			_load_progress_timer.stop()
			return
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			if loading_screen != null:
				loading_screen.update_bar(load_progress[0] * 100)
		ResourceLoader.THREAD_LOAD_FAILED:
			_content_failed_to_load.emit(_content_path)
			_load_progress_timer.stop()
			return
		ResourceLoader.THREAD_LOAD_LOADED:
			_load_progress_timer.stop()
			_load_progress_timer.queue_free()
			_content_finished_loading.emit(ResourceLoader.load_threaded_get(_content_path).instantiate())
			return
	

func _on_content_failed_to_load(content_path : String):
	printerr("error: Failed to load resource: '%s'" % [content_path])


func _on_content_finished_loading(content):
	var outgoing_scene = get_tree().current_scene
	
	var incoming_data : LevelDataHandoff
	if get_tree().current_scene is LevelManager:
		incoming_data = get_tree().current_scene.data as LevelDataHandoff
	
	if content is LevelManager:
		content.data = incoming_data
		
	outgoing_scene.queue_free()
	
	get_tree().root.call_deferred("add_child", content)
	get_tree().set_deferred("current_scene", content)
	
	if loading_screen != null:
		loading_screen.finish_transition()
		
		if content is LevelManager:
			content.init_player_location()
			
		await  loading_screen.anim_player.animation_finished
		loading_screen = null
		
		if content is LevelManager:
			content.enter_level()


func _on_content_invalid(content_path : String):
	printerr("error: Failed to load resource: '%s'" % [content_path])
