extends CharacterBody2D
class_name Base_Enemy

var target : Vector2
var current_following_character : Node2D

@export var min_distance_to_target = 10.0
@export var max_distance_to_listen = 200.0
@export var distance_to_follow_actual_character = 80.0
@export var speed = 300.0
@export var acceleration = 10.0
@export var damage = 5.0
@export var on_hit_cooldown = 2.0
var current_hit_cooldown = 0.0
@onready var navigation_agent : NavigationAgent2D = $Navigation/NavigationAgent2D
@export var soundwave : PackedScene
@export var light_marker : LightMarker
@export var animated_sprite : AnimatedSprite2D

signal  Character_Damage(dmg : float, position : Vector2)

# Called when the node enters the scene tree for the first time.
func _ready():
	target = global_position
	current_following_character = get_tree().get_nodes_in_group("Player")[0]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	movement_control(delta)
	move_and_slide()
	collision_interaction()
	pass

func movement_control(delta):
	if(current_hit_cooldown <= 0.0):
		if(current_following_character != null and global_position.distance_to(current_following_character.global_position) < distance_to_follow_actual_character):
			target = current_following_character.global_position
			animated_sprite.play("walk")
			if target.x > global_position.x:
				animated_sprite.scale = Vector2(1,1)
			else:
				animated_sprite.scale = Vector2(-1,1)
			if !light_marker.varySize:
				light_marker.varySize = true
				light_marker.increasing = true		
		if(target != null and global_position.distance_to(target) > min_distance_to_target):
			var direction = Vector2.ZERO

			direction = navigation_agent.get_next_path_position() - global_position
			direction = direction.normalized()
			if direction.x > 0:
				animated_sprite.scale = Vector2(1,1)
			else:
				animated_sprite.scale = Vector2(-1,1)
			velocity = velocity.lerp(direction * speed, acceleration * delta)
			animated_sprite.play("walk")
		else:
			stop()
		
	else:
		current_hit_cooldown -= delta
		stop()

func stop():
		velocity = Vector2.ZERO
		light_marker.varySize = false
		light_marker.turnOff = true
		animated_sprite.play("idle")
		
func set_target(newTarget : Node2D, byPassDistance : bool):
	print(global_position.distance_to(newTarget.global_position))
	if(global_position.distance_to(newTarget.global_position) < max_distance_to_listen or byPassDistance):
		target = newTarget.global_position
		current_following_character = newTarget
		var wave = soundwave.instantiate()
		get_parent().add_child(wave)
		wave.set_values(position)

		light_marker.varySize = true
		light_marker.increasing = true


func _on_timer_timeout():
	if (target != null):
		navigation_agent.target_position = target
	pass # Replace with function body.


func _on_character_sound_emission(pos, byPassDistance):
	set_target(pos, byPassDistance)
	pass # Replace with function body.
	
func collision_interaction():
	if (current_hit_cooldown <= 0.0):
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			var player : Player = collider as Player
			
			if player:
				emit_signal("Character_Damage", damage, global_position)
				current_hit_cooldown = on_hit_cooldown
			
