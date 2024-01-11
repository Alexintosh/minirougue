extends CharacterBody2D

var health = 3
var velocity_factor = 500
var damage_rate = 10
var points_to_player = 1
var label = "mob"

@onready var player = get_node("/root/Game/Player")
signal enemy_dead

func _ready():
	%Slime.play_walk()

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * velocity_factor
	move_and_slide()

func take_damage():
	health -= 1
	%Slime.play_hurt()
	
	if(health <= 0): 
		queue_free()
		enemy_dead.emit(points_to_player, label)
		
	const EXPLOSION = preload("res://smoke_explosion/smoke_explosion.tscn")
	var smoke = EXPLOSION.instantiate()
	
	get_parent().add_child(smoke)
	smoke.global_position = global_position
