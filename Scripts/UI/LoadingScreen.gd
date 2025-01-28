class_name LoadingScreen extends CanvasLayer

signal transition_in_complete
@onready var progress_bar : ProgressBar = $Control/ProgressBar
@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var timer : Timer = $Timer

var starting_animation_name : String
# Called when the node enters the scene tree for the first time.
func _ready():
	progress_bar.visible = false


func start_transition(animation_name : String):
	if !anim_player.has_animation(animation_name):
		push_warning("'%s' animation does not exist" % animation_name)
		animation_name = "fade_to_black"
	starting_animation_name = animation_name
	anim_player.play(animation_name)
	
	timer.start()
	
func finish_transition():
	if timer:
		timer.stop()
		
	var ending_animation_name : String = starting_animation_name.replace("to", "from")
	
	if !anim_player.has_animation(ending_animation_name):
		push_warning("'%s' animation does not exist" % ending_animation_name)
		ending_animation_name = "fade_from_black"
	
	anim_player.play(ending_animation_name)
	
	await anim_player.animation_finished
	
	queue_free()
	
func report_midpoint():
	transition_in_complete.emit()
	
func _on_timer_timeout():
	progress_bar.visible = true
	
func update_bar(value : float):
	progress_bar.value = value
