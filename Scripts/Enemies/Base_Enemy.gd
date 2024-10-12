extends CharacterBody2D
class_name Base_Enemy

var target : Vector2
var current_following_character : Node2D

@export var min_distance_to_target = 10.0
@export var max_distance_to_listen = 200.0
@export var distance_to_follow_actual_character = 80.0
@export var speed = 300.0
@export var acceleration = 10.0
@onready var navigation_agent : NavigationAgent2D = $Navigation/NavigationAgent2D
# Called when the node enters the scene tree for the first time.
func _ready():
	target = global_position
	current_following_character = get_tree().get_nodes_in_group("Player")[0]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(global_position.distance_to(current_following_character.global_position) < distance_to_follow_actual_character):
		target = current_following_character.global_position		
	if(target != null and global_position.distance_to(target) > min_distance_to_target):
		var direction = Vector2.ZERO

		direction = navigation_agent.get_next_path_position() - global_position
		direction = direction.normalized()
		
		velocity = velocity.lerp(direction * speed, acceleration * delta)
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	pass
	
func set_target(newTarget : Node2D, byPassDistance : bool):
	print(global_position.distance_to(newTarget.global_position))
	if(global_position.distance_to(newTarget.global_position) < max_distance_to_listen or byPassDistance):
		target = newTarget.global_position
		current_following_character = newTarget


func _on_timer_timeout():
	if (target != null):
		navigation_agent.target_position = target
	pass # Replace with function body.


func _on_character_sound_emission(pos, byPassDistance):
	set_target(pos, byPassDistance)
	pass # Replace with function body.
