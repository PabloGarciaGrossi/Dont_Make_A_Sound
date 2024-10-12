extends Sound_Emitter
class_name Player

@export var SPEED = 100.0
@export var ACCEL = 10.0
@export var COOLDOWN_VOICE = 1.0
var input: Vector2
var current_voice_cd = 0

@export var soundwave : PackedScene
@export var animated_sprite : AnimatedSprite2D
var wave

var record_bus_index: int
var record_effect : AudioEffectRecord

@export var streamPlayer : AudioStreamPlayer2D
# Called when the node enters the scene tree for the first time.
func _ready():
	streamPlayer.play()
	record_bus_index = AudioServer.get_bus_index('Microphone')
	record_effect = AudioServer.get_bus_effect(record_bus_index, 0)
	
	#print(AudioServer.get_input_device_list())
	var mic_list = AudioServer.get_input_device_list()
	for i in mic_list:
		print(i)
		streamPlayer.play()
		AudioServer.set_input_device(i)
		print(AudioServer.input_device)
	#record_effect.set_recording_active(true)
	
	pass # Replace with function body.
	
	
func get_input():
	input.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	
	if(input.x != 0 or input.y != 0):
		animated_sprite.play("walk")
		if(input.x > 0):
			animated_sprite.scale = Vector2(1,1)
		elif(input.x < 0):
			animated_sprite.scale = Vector2(-1,1)
	elif(input.x == 0 and input.y == 0):
		animated_sprite.play("idle")
	return input.normalized()
	
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_input = get_input()
	
	velocity = lerp(velocity, player_input * SPEED, ACCEL * delta)
	move_and_slide()
	
	current_voice_cd += delta
	var sample = AudioServer.get_bus_peak_volume_left_db(record_bus_index, 0)
	var linear_sample = db_to_linear(sample)
	#print(linear_sample)
	
	if Input.is_action_just_pressed("Interact") && current_voice_cd > COOLDOWN_VOICE && wave == null:
		wave = soundwave.instantiate()
		get_parent().add_child(wave)
		wave.set_values(position)
		emit_signal("Sound_Emission", self, false)
		current_voice_cd = 0
	pass
